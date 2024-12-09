module PRIMME
using SparseArrays
using Accessors
using LinearAlgebra
# Write your package code here.
include("../lib/LibPRIMME.jl")
const LP = LibPRIMME
export LibPRIMME
# TODO: Allow striding
function matrixMatvecSA(x, ldx, y, ldy, blockSize, transpose, params, ierr)
    params = unsafe_load(params)
    blockSize = unsafe_load(blockSize)
    X = unsafe_wrap(Array, Ptr{Float64}(x), convert.(Int, (params.nLocal, blockSize)))
    Y = unsafe_wrap(Array, Ptr{Float64}(y), convert.(Int, (params.mLocal, blockSize)))
    A = unsafe_pointer_to_objref(convert(Ptr{SparseMatrixCSC{Float64, Int64}}, params.matrix))[]
    try
        if iszero(unsafe_load(transpose))
            mul!(Y, A, X)
        else
            mul!(Y, A', X)
        end
    catch e
        println(e)
        unsafe_store!(ierr, 117)
    end
    unsafe_store!(ierr, 0)
    return nothing
end

mutable struct Solver{M}
    params::Ref{LP.primme_svds_params}
    A::Ref{M}
    fresh::Bool
    matvec::Ptr{Nothing}
    svals::Cint
    function Solver(A::M, svals = 6) where M
        r = Ref{LP.primme_svds_params}()
        matvec = @cfunction(
            PRIMME.matrixMatvecSA, 
            Cvoid, 
            (Ptr{Cvoid}, Ptr{LibPRIMME.PRIMME_INT}, Ptr{Cvoid},
            Ptr{LibPRIMME.PRIMME_INT}, Ptr{Cint}, Ptr{Cint}, Ptr{LibPRIMME.primme_svds_params}, Ptr{Cint})
        )
        S = new{M}(r, Ref(A), true, matvec, svals)
        _setparams(S)
        S.matrixMatvec = matvec
        return S
    end
end
function _setparams(s::Solver)
    if s.fresh
        LP.primme_svds_initialize(s.params)
        s.matrix = Base.unsafe_convert(Ptr{Cvoid}, s.A)
        s.m = size(s.A[], 1)
        s.n = size(s.A[], 2)
        s.numSvals = s.svals
        LP.primme_svds_set_method(
            LP.primme_svds_hybrid, 
            LP.PRIMME_DEFAULT_METHOD, 
            LP.PRIMME_DEFAULT_METHOD,
            s.params
        )
        # TODO: Generalize
        s.fresh = false
    end
end

function solve!(s::Solver, svals, svecs, resNorms; largest = true)
    _setparams(s)
    if largest
        s.target = LP.primme_svds_largest
    else
        s.target = LP.primme_svds_smallest
    end
    retcode = LP.dprimme_svds(svals, svecs, resNorms, s.params)
    return svals, retcode
end
function solve!(s::Solver, nvals = s.svals; largest = true)
    if nvals != s.svals
        s.svals = nvals
    end
    svals = zeros(nvals)
    svecs = Matrix{eltype(s.A[])}(undef, prod(size(s.A[])), nvals)
    resNorms = zeros(nvals)
    retcode = solve!(s, svals, svecs, resNorms; largest)
    return svals, retcode
end

function Base.getproperty(s::Solver, name::Symbol)
    if name ∈ fieldnames(Solver)
        return getfield(s, name)
    else
        return getproperty(getfield(s, :params)[], name)
    end
end
function Base.setproperty!(s::Solver, name::Symbol, x)
    if name ∈ fieldnames(Solver)
        setfield!(s, :fresh, true)
        return setfield!(s, name, x)
    else
        params = s.params[]
        params = set(params, PropertyLens{name}(), x)
        s.params[] = params
        return s
    end
end
end
