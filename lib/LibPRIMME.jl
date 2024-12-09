module LibPRIMME
using PRIMME_jll
const libprimme = PRIMME_jll.libprimme
to_c_type(t::Type) = t
to_c_type_pairs(va_list) = map(enumerate(to_c_type.(va_list))) do (ind, type)
    :(va_list[$ind]::$type)
end

struct _primme_complex_half
    r::Float16
    i::Float16
end

@enum primme_target::UInt32 begin
    primme_smallest = 0
    primme_largest = 1
    primme_closest_geq = 2
    primme_closest_leq = 3
    primme_closest_abs = 4
    primme_largest_abs = 5
end

@enum primme_projection::UInt32 begin
    primme_proj_default = 0
    primme_proj_RR = 1
    primme_proj_harmonic = 2
    primme_proj_refined = 3
end

@enum primme_init::UInt32 begin
    primme_init_default = 0
    primme_init_krylov = 1
    primme_init_random = 2
    primme_init_user = 3
end

@enum primme_convergencetest::UInt32 begin
    primme_full_LTolerance = 0
    primme_decreasing_LTolerance = 1
    primme_adaptive_ETolerance = 2
    primme_adaptive = 3
end

@enum primme_event::UInt32 begin
    primme_event_outer_iteration = 0
    primme_event_inner_iteration = 1
    primme_event_restart = 2
    primme_event_reset = 3
    primme_event_converged = 4
    primme_event_locked = 5
    primme_event_message = 6
    primme_event_profile = 7
end

@enum primme_orth::UInt32 begin
    primme_orth_default = 0
    primme_orth_implicit_I = 1
    primme_orth_explicit_I = 2
end

@enum primme_op_datatype::UInt32 begin
    primme_op_default = 0
    primme_op_half = 1
    primme_op_float = 2
    primme_op_double = 3
    primme_op_quad = 4
    primme_op_int = 5
end

struct primme_stats
    numOuterIterations::Int64
    numRestarts::Int64
    numMatvecs::Int64
    numPreconds::Int64
    numGlobalSum::Int64
    numBroadcast::Int64
    volumeGlobalSum::Int64
    volumeBroadcast::Int64
    flopsDense::Cdouble
    numOrthoInnerProds::Cdouble
    elapsedTime::Cdouble
    timeMatvec::Cdouble
    timePrecond::Cdouble
    timeOrtho::Cdouble
    timeGlobalSum::Cdouble
    timeBroadcast::Cdouble
    timeDense::Cdouble
    estimateMinEVal::Cdouble
    estimateMaxEVal::Cdouble
    estimateLargestSVal::Cdouble
    estimateBNorm::Cdouble
    estimateInvBNorm::Cdouble
    maxConvTol::Cdouble
    estimateResidualError::Cdouble
    lockingIssue::Int64
end

struct JD_projectors
    LeftQ::Cint
    LeftX::Cint
    RightQ::Cint
    RightX::Cint
    SkewQ::Cint
    SkewX::Cint
end

struct projection_params
    projection::primme_projection
end

struct correction_params
    precondition::Cint
    robustShifts::Cint
    maxInnerIterations::Cint
    projectors::JD_projectors
    convTest::primme_convergencetest
    relTolBase::Cdouble
end

struct restarting_params
    maxPrevRetain::Cint
end

struct primme_params
    n::Int64
    matrixMatvec::Ptr{Cvoid}
    matrixMatvec_type::primme_op_datatype
    applyPreconditioner::Ptr{Cvoid}
    applyPreconditioner_type::primme_op_datatype
    massMatrixMatvec::Ptr{Cvoid}
    massMatrixMatvec_type::primme_op_datatype
    numProcs::Cint
    procID::Cint
    nLocal::Int64
    commInfo::Ptr{Cvoid}
    globalSumReal::Ptr{Cvoid}
    globalSumReal_type::primme_op_datatype
    broadcastReal::Ptr{Cvoid}
    broadcastReal_type::primme_op_datatype
    numEvals::Cint
    target::primme_target
    numTargetShifts::Cint
    targetShifts::Ptr{Cdouble}
    dynamicMethodSwitch::Cint
    locking::Cint
    initSize::Cint
    numOrthoConst::Cint
    maxBasisSize::Cint
    minRestartSize::Cint
    maxBlockSize::Cint
    maxMatvecs::Int64
    maxOuterIterations::Int64
    iseed::NTuple{4, Int64}
    aNorm::Cdouble
    BNorm::Cdouble
    invBNorm::Cdouble
    eps::Cdouble
    orth::primme_orth
    internalPrecision::primme_op_datatype
    printLevel::Cint
    outputFile::Ptr{Libc.FILE}
    matrix::Ptr{Cvoid}
    preconditioner::Ptr{Cvoid}
    massMatrix::Ptr{Cvoid}
    ShiftsForPreconditioner::Ptr{Cdouble}
    initBasisMode::primme_init
    ldevecs::Int64
    ldOPs::Int64
    projectionParams::projection_params
    restartingParams::restarting_params
    correctionParams::correction_params
    stats::primme_stats
    convTestFun::Ptr{Cvoid}
    convTestFun_type::primme_op_datatype
    convtest::Ptr{Cvoid}
    monitorFun::Ptr{Cvoid}
    monitorFun_type::primme_op_datatype
    monitor::Ptr{Cvoid}
    queue::Ptr{Cvoid}
    profile::Ptr{Cchar}
end

@enum primme_preset_method::UInt32 begin
    PRIMME_DEFAULT_METHOD = 0
    PRIMME_DYNAMIC = 1
    PRIMME_DEFAULT_MIN_TIME = 2
    PRIMME_DEFAULT_MIN_MATVECS = 3
    PRIMME_Arnoldi = 4
    PRIMME_GD = 5
    PRIMME_GD_plusK = 6
    PRIMME_GD_Olsen_plusK = 7
    PRIMME_JD_Olsen_plusK = 8
    PRIMME_RQI = 9
    PRIMME_JDQR = 10
    PRIMME_JDQMR = 11
    PRIMME_JDQMR_ETol = 12
    PRIMME_STEEPEST_DESCENT = 13
    PRIMME_LOBPCG_OrthoBasis = 14
    PRIMME_LOBPCG_OrthoBasis_Window = 15
end

@enum primme_type::UInt32 begin
    primme_int = 0
    primme_double = 1
    primme_pointer = 2
    primme_string = 3
end

@enum primme_params_label::UInt32 begin
    PRIMME_n = 1
    PRIMME_matrixMatvec = 2
    PRIMME_matrixMatvec_type = 3
    PRIMME_applyPreconditioner = 4
    PRIMME_applyPreconditioner_type = 5
    PRIMME_massMatrixMatvec = 6
    PRIMME_massMatrixMatvec_type = 7
    PRIMME_numProcs = 8
    PRIMME_procID = 9
    PRIMME_commInfo = 10
    PRIMME_nLocal = 11
    PRIMME_globalSumReal = 12
    PRIMME_globalSumReal_type = 13
    PRIMME_broadcastReal = 14
    PRIMME_broadcastReal_type = 15
    PRIMME_numEvals = 16
    PRIMME_target = 17
    PRIMME_numTargetShifts = 18
    PRIMME_targetShifts = 19
    PRIMME_locking = 20
    PRIMME_initSize = 21
    PRIMME_numOrthoConst = 22
    PRIMME_maxBasisSize = 23
    PRIMME_minRestartSize = 24
    PRIMME_maxBlockSize = 25
    PRIMME_maxMatvecs = 26
    PRIMME_maxOuterIterations = 27
    PRIMME_iseed = 28
    PRIMME_aNorm = 29
    PRIMME_BNorm = 30
    PRIMME_invBNorm = 31
    PRIMME_eps = 32
    PRIMME_orth = 33
    PRIMME_internalPrecision = 34
    PRIMME_printLevel = 35
    PRIMME_outputFile = 36
    PRIMME_matrix = 37
    PRIMME_massMatrix = 38
    PRIMME_preconditioner = 39
    PRIMME_ShiftsForPreconditioner = 40
    PRIMME_initBasisMode = 41
    PRIMME_projectionParams_projection = 42
    PRIMME_restartingParams_maxPrevRetain = 43
    PRIMME_correctionParams_precondition = 44
    PRIMME_correctionParams_robustShifts = 45
    PRIMME_correctionParams_maxInnerIterations = 46
    PRIMME_correctionParams_projectors_LeftQ = 47
    PRIMME_correctionParams_projectors_LeftX = 48
    PRIMME_correctionParams_projectors_RightQ = 49
    PRIMME_correctionParams_projectors_RightX = 50
    PRIMME_correctionParams_projectors_SkewQ = 51
    PRIMME_correctionParams_projectors_SkewX = 52
    PRIMME_correctionParams_convTest = 53
    PRIMME_correctionParams_relTolBase = 54
    PRIMME_stats_numOuterIterations = 55
    PRIMME_stats_numRestarts = 56
    PRIMME_stats_numMatvecs = 57
    PRIMME_stats_numPreconds = 58
    PRIMME_stats_numGlobalSum = 59
    PRIMME_stats_volumeGlobalSum = 60
    PRIMME_stats_numBroadcast = 61
    PRIMME_stats_volumeBroadcast = 62
    PRIMME_stats_flopsDense = 63
    PRIMME_stats_numOrthoInnerProds = 64
    PRIMME_stats_elapsedTime = 65
    PRIMME_stats_timeMatvec = 66
    PRIMME_stats_timePrecond = 67
    PRIMME_stats_timeOrtho = 68
    PRIMME_stats_timeGlobalSum = 69
    PRIMME_stats_timeBroadcast = 70
    PRIMME_stats_timeDense = 71
    PRIMME_stats_estimateMinEVal = 72
    PRIMME_stats_estimateMaxEVal = 73
    PRIMME_stats_estimateLargestSVal = 74
    PRIMME_stats_estimateBNorm = 75
    PRIMME_stats_estimateInvBNorm = 76
    PRIMME_stats_maxConvTol = 77
    PRIMME_stats_lockingIssue = 78
    PRIMME_dynamicMethodSwitch = 79
    PRIMME_convTestFun = 80
    PRIMME_convTestFun_type = 81
    PRIMME_convtest = 82
    PRIMME_ldevecs = 83
    PRIMME_ldOPs = 84
    PRIMME_monitorFun = 85
    PRIMME_monitorFun_type = 86
    PRIMME_monitor = 87
    PRIMME_queue = 88
    PRIMME_profile = 89
end

"""
    hprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int hprimme(PRIMME_HALF *evals, PRIMME_HALF *evecs, PRIMME_HALF *resNorms, primme_params *primme);
```
"""
function hprimme(evals, evecs, resNorms, primme)
    ccall((:hprimme, libprimme), Cint, (Ptr{Float16}, Ptr{Float16}, Ptr{Float16}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    kprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int kprimme(PRIMME_HALF *evals, PRIMME_COMPLEX_HALF *evecs, PRIMME_HALF *resNorms, primme_params *primme);
```
"""
function kprimme(evals, evecs, resNorms, primme)
    ccall((:kprimme, libprimme), Cint, (Ptr{Float16}, Ptr{_primme_complex_half}, Ptr{Float16}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    sprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int sprimme(float *evals, float *evecs, float *resNorms, primme_params *primme);
```
"""
function sprimme(evals, evecs, resNorms, primme)
    ccall((:sprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    cprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int cprimme(float *evals, PRIMME_COMPLEX_FLOAT *evecs, float *resNorms, primme_params *primme);
```
"""
function cprimme(evals, evecs, resNorms, primme)
    ccall((:cprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{ComplexF32}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    dprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int dprimme(double *evals, double *evecs, double *resNorms, primme_params *primme);
```
"""
function dprimme(evals, evecs, resNorms, primme)
    ccall((:dprimme, libprimme), Cint, (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    zprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int zprimme(double *evals, PRIMME_COMPLEX_DOUBLE *evecs, double *resNorms, primme_params *primme);
```
"""
function zprimme(evals, evecs, resNorms, primme)
    ccall((:zprimme, libprimme), Cint, (Ptr{Cdouble}, Ptr{ComplexF32}, Ptr{Cdouble}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_hprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_hprimme(PRIMME_HALF *evals, PRIMME_HALF *evecs, PRIMME_HALF *resNorms, primme_params *primme);
```
"""
function magma_hprimme(evals, evecs, resNorms, primme)
    ccall((:magma_hprimme, libprimme), Cint, (Ptr{Float16}, Ptr{Float16}, Ptr{Float16}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_kprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_kprimme(PRIMME_HALF *evals, PRIMME_COMPLEX_HALF *evecs, PRIMME_HALF *resNorms, primme_params *primme);
```
"""
function magma_kprimme(evals, evecs, resNorms, primme)
    ccall((:magma_kprimme, libprimme), Cint, (Ptr{Float16}, Ptr{_primme_complex_half}, Ptr{Float16}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_sprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_sprimme(float *evals, float *evecs, float *resNorms, primme_params *primme);
```
"""
function magma_sprimme(evals, evecs, resNorms, primme)
    ccall((:magma_sprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_cprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_cprimme(float *evals, PRIMME_COMPLEX_FLOAT *evecs, float *resNorms, primme_params *primme);
```
"""
function magma_cprimme(evals, evecs, resNorms, primme)
    ccall((:magma_cprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{ComplexF32}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_dprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_dprimme(double *evals, double *evecs, double *resNorms, primme_params *primme);
```
"""
function magma_dprimme(evals, evecs, resNorms, primme)
    ccall((:magma_dprimme, libprimme), Cint, (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_zprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_zprimme(double *evals, PRIMME_COMPLEX_DOUBLE *evecs, double *resNorms, primme_params *primme);
```
"""
function magma_zprimme(evals, evecs, resNorms, primme)
    ccall((:magma_zprimme, libprimme), Cint, (Ptr{Cdouble}, Ptr{ComplexF32}, Ptr{Cdouble}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    hsprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int hsprimme(float *evals, PRIMME_HALF *evecs, float *resNorms, primme_params *primme);
```
"""
function hsprimme(evals, evecs, resNorms, primme)
    ccall((:hsprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{Float16}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    ksprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int ksprimme(float *evals, PRIMME_COMPLEX_HALF *evecs, float *resNorms, primme_params *primme);
```
"""
function ksprimme(evals, evecs, resNorms, primme)
    ccall((:ksprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{_primme_complex_half}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_hsprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_hsprimme(float *evals, PRIMME_HALF *evecs, float *resNorms, primme_params *primme);
```
"""
function magma_hsprimme(evals, evecs, resNorms, primme)
    ccall((:magma_hsprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{Float16}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_ksprimme(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_ksprimme(float *evals, PRIMME_COMPLEX_HALF *evecs, float *resNorms, primme_params *primme);
```
"""
function magma_ksprimme(evals, evecs, resNorms, primme)
    ccall((:magma_ksprimme, libprimme), Cint, (Ptr{Cfloat}, Ptr{_primme_complex_half}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    kprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int kprimme_normal(PRIMME_COMPLEX_HALF *evals, PRIMME_COMPLEX_HALF *evecs, PRIMME_HALF *resNorms, primme_params *primme);
```
"""
function kprimme_normal(evals, evecs, resNorms, primme)
    ccall((:kprimme_normal, libprimme), Cint, (Ptr{_primme_complex_half}, Ptr{_primme_complex_half}, Ptr{Float16}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    cprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int cprimme_normal(PRIMME_COMPLEX_FLOAT *evals, PRIMME_COMPLEX_FLOAT *evecs, float *resNorms, primme_params *primme);
```
"""
function cprimme_normal(evals, evecs, resNorms, primme)
    ccall((:cprimme_normal, libprimme), Cint, (Ptr{ComplexF32}, Ptr{ComplexF32}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    zprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int zprimme_normal(PRIMME_COMPLEX_DOUBLE *evals, PRIMME_COMPLEX_DOUBLE *evecs, double *resNorms, primme_params *primme);
```
"""
function zprimme_normal(evals, evecs, resNorms, primme)
    ccall((:zprimme_normal, libprimme), Cint, (Ptr{ComplexF32}, Ptr{ComplexF32}, Ptr{Cdouble}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_kprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_kprimme_normal(PRIMME_COMPLEX_HALF *evals, PRIMME_COMPLEX_HALF *evecs, PRIMME_HALF *resNorms, primme_params *primme);
```
"""
function magma_kprimme_normal(evals, evecs, resNorms, primme)
    ccall((:magma_kprimme_normal, libprimme), Cint, (Ptr{_primme_complex_half}, Ptr{_primme_complex_half}, Ptr{Float16}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_cprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_cprimme_normal(PRIMME_COMPLEX_FLOAT *evals, PRIMME_COMPLEX_FLOAT *evecs, float *resNorms, primme_params *primme);
```
"""
function magma_cprimme_normal(evals, evecs, resNorms, primme)
    ccall((:magma_cprimme_normal, libprimme), Cint, (Ptr{ComplexF32}, Ptr{ComplexF32}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_zprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_zprimme_normal(PRIMME_COMPLEX_DOUBLE *evals, PRIMME_COMPLEX_DOUBLE *evecs, double *resNorms, primme_params *primme);
```
"""
function magma_zprimme_normal(evals, evecs, resNorms, primme)
    ccall((:magma_zprimme_normal, libprimme), Cint, (Ptr{ComplexF32}, Ptr{ComplexF32}, Ptr{Cdouble}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    kcprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int kcprimme_normal(PRIMME_COMPLEX_FLOAT *evals, PRIMME_COMPLEX_HALF *evecs, float *resNorms, primme_params *primme);
```
"""
function kcprimme_normal(evals, evecs, resNorms, primme)
    ccall((:kcprimme_normal, libprimme), Cint, (Ptr{ComplexF32}, Ptr{_primme_complex_half}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    magma_kcprimme_normal(evals, evecs, resNorms, primme)


### Prototype
```c
int magma_kcprimme_normal(PRIMME_COMPLEX_FLOAT *evals, PRIMME_COMPLEX_HALF *evecs, float *resNorms, primme_params *primme);
```
"""
function magma_kcprimme_normal(evals, evecs, resNorms, primme)
    ccall((:magma_kcprimme_normal, libprimme), Cint, (Ptr{ComplexF32}, Ptr{_primme_complex_half}, Ptr{Cfloat}, Ptr{primme_params}), evals, evecs, resNorms, primme)
end

"""
    primme_params_create()


### Prototype
```c
primme_params* primme_params_create(void);
```
"""
function primme_params_create()
    ccall((:primme_params_create, libprimme), Ptr{primme_params}, ())
end

"""
    primme_params_destroy(primme)


### Prototype
```c
int primme_params_destroy(primme_params *primme);
```
"""
function primme_params_destroy(primme)
    ccall((:primme_params_destroy, libprimme), Cint, (Ptr{primme_params},), primme)
end

"""
    primme_initialize(primme)


### Prototype
```c
void primme_initialize(primme_params *primme);
```
"""
function primme_initialize(primme)
    ccall((:primme_initialize, libprimme), Cvoid, (Ptr{primme_params},), primme)
end

"""
    primme_set_method(method, params)


### Prototype
```c
int primme_set_method(primme_preset_method method, primme_params *params);
```
"""
function primme_set_method(method, params)
    ccall((:primme_set_method, libprimme), Cint, (primme_preset_method, Ptr{primme_params}), method, params)
end

"""
    primme_display_params(primme)


### Prototype
```c
void primme_display_params(primme_params primme);
```
"""
function primme_display_params(primme)
    ccall((:primme_display_params, libprimme), Cvoid, (primme_params,), primme)
end

"""
    primme_free(primme)


### Prototype
```c
void primme_free(primme_params *primme);
```
"""
function primme_free(primme)
    ccall((:primme_free, libprimme), Cvoid, (Ptr{primme_params},), primme)
end

"""
    primme_get_member(primme, label, value)


### Prototype
```c
int primme_get_member(primme_params *primme, primme_params_label label, void *value);
```
"""
function primme_get_member(primme, label, value)
    ccall((:primme_get_member, libprimme), Cint, (Ptr{primme_params}, primme_params_label, Ptr{Cvoid}), primme, label, value)
end

"""
    primme_set_member(primme, label, value)


### Prototype
```c
int primme_set_member(primme_params *primme, primme_params_label label, void *value);
```
"""
function primme_set_member(primme, label, value)
    ccall((:primme_set_member, libprimme), Cint, (Ptr{primme_params}, primme_params_label, Ptr{Cvoid}), primme, label, value)
end

"""
    primme_member_info(label, label_name, type, arity)


### Prototype
```c
int primme_member_info(primme_params_label *label, const char** label_name, primme_type *type, int *arity);
```
"""
function primme_member_info(label, label_name, type, arity)
    ccall((:primme_member_info, libprimme), Cint, (Ptr{primme_params_label}, Ptr{Ptr{Cchar}}, Ptr{primme_type}, Ptr{Cint}), label, label_name, type, arity)
end

"""
    primme_constant_info(label_name, value)


### Prototype
```c
int primme_constant_info(const char* label_name, int *value);
```
"""
function primme_constant_info(label_name, value)
    ccall((:primme_constant_info, libprimme), Cint, (Ptr{Cchar}, Ptr{Cint}), label_name, value)
end

"""
    primme_enum_member_info(label, value, value_name)


### Prototype
```c
int primme_enum_member_info( primme_params_label label, int *value, const char **value_name);
```
"""
function primme_enum_member_info(label, value, value_name)
    ccall((:primme_enum_member_info, libprimme), Cint, (primme_params_label, Ptr{Cint}, Ptr{Ptr{Cchar}}), label, value, value_name)
end

@enum primme_svds_target::UInt32 begin
    primme_svds_largest = 0
    primme_svds_smallest = 1
    primme_svds_closest_abs = 2
end

@enum primme_svds_preset_method::UInt32 begin
    primme_svds_default = 0
    primme_svds_hybrid = 1
    primme_svds_normalequations = 2
    primme_svds_augmented = 3
end

@enum primme_svds_operator::UInt32 begin
    primme_svds_op_none = 0
    primme_svds_op_AtA = 1
    primme_svds_op_AAt = 2
    primme_svds_op_augmented = 3
end

struct primme_svds_stats
    numOuterIterations::Int64
    numRestarts::Int64
    numMatvecs::Int64
    numPreconds::Int64
    numGlobalSum::Int64
    numBroadcast::Int64
    volumeGlobalSum::Int64
    volumeBroadcast::Int64
    numOrthoInnerProds::Cdouble
    elapsedTime::Cdouble
    timeMatvec::Cdouble
    timePrecond::Cdouble
    timeOrtho::Cdouble
    timeGlobalSum::Cdouble
    timeBroadcast::Cdouble
    lockingIssue::Int64
end

struct primme_svds_params
    primme::primme_params
    primmeStage2::primme_params
    m::Int64
    n::Int64
    matrixMatvec::Ptr{Cvoid}
    matrixMatvec_type::primme_op_datatype
    applyPreconditioner::Ptr{Cvoid}
    applyPreconditioner_type::primme_op_datatype
    numProcs::Cint
    procID::Cint
    mLocal::Int64
    nLocal::Int64
    commInfo::Ptr{Cvoid}
    globalSumReal::Ptr{Cvoid}
    globalSumReal_type::primme_op_datatype
    broadcastReal::Ptr{Cvoid}
    broadcastReal_type::primme_op_datatype
    numSvals::Cint
    target::primme_svds_target
    numTargetShifts::Cint
    targetShifts::Ptr{Cdouble}
    method::primme_svds_operator
    methodStage2::primme_svds_operator
    matrix::Ptr{Cvoid}
    preconditioner::Ptr{Cvoid}
    locking::Cint
    numOrthoConst::Cint
    aNorm::Cdouble
    eps::Cdouble
    precondition::Cint
    initSize::Cint
    maxBasisSize::Cint
    maxBlockSize::Cint
    maxMatvecs::Int64
    iseed::NTuple{4, Int64}
    printLevel::Cint
    internalPrecision::primme_op_datatype
    outputFile::Ptr{Libc.FILE}
    stats::primme_svds_stats
    convTestFun::Ptr{Cvoid}
    convTestFun_type::primme_op_datatype
    convtest::Ptr{Cvoid}
    monitorFun::Ptr{Cvoid}
    monitorFun_type::primme_op_datatype
    monitor::Ptr{Cvoid}
    queue::Ptr{Cvoid}
    profile::Ptr{Cchar}
end

@enum primme_svds_params_label::UInt32 begin
    PRIMME_SVDS_primme = 1
    PRIMME_SVDS_primmeStage2 = 2
    PRIMME_SVDS_m = 3
    PRIMME_SVDS_n = 4
    PRIMME_SVDS_matrixMatvec = 5
    PRIMME_SVDS_matrixMatvec_type = 6
    PRIMME_SVDS_applyPreconditioner = 7
    PRIMME_SVDS_applyPreconditioner_type = 8
    PRIMME_SVDS_numProcs = 9
    PRIMME_SVDS_procID = 10
    PRIMME_SVDS_mLocal = 11
    PRIMME_SVDS_nLocal = 12
    PRIMME_SVDS_commInfo = 13
    PRIMME_SVDS_globalSumReal = 14
    PRIMME_SVDS_globalSumReal_type = 15
    PRIMME_SVDS_broadcastReal = 16
    PRIMME_SVDS_broadcastReal_type = 17
    PRIMME_SVDS_numSvals = 18
    PRIMME_SVDS_target = 19
    PRIMME_SVDS_numTargetShifts = 20
    PRIMME_SVDS_targetShifts = 21
    PRIMME_SVDS_method = 22
    PRIMME_SVDS_methodStage2 = 23
    PRIMME_SVDS_matrix = 24
    PRIMME_SVDS_preconditioner = 25
    PRIMME_SVDS_locking = 26
    PRIMME_SVDS_numOrthoConst = 27
    PRIMME_SVDS_aNorm = 28
    PRIMME_SVDS_eps = 29
    PRIMME_SVDS_precondition = 30
    PRIMME_SVDS_initSize = 31
    PRIMME_SVDS_maxBasisSize = 32
    PRIMME_SVDS_maxBlockSize = 33
    PRIMME_SVDS_maxMatvecs = 34
    PRIMME_SVDS_iseed = 35
    PRIMME_SVDS_printLevel = 36
    PRIMME_SVDS_internalPrecision = 37
    PRIMME_SVDS_outputFile = 38
    PRIMME_SVDS_stats_numOuterIterations = 39
    PRIMME_SVDS_stats_numRestarts = 40
    PRIMME_SVDS_stats_numMatvecs = 41
    PRIMME_SVDS_stats_numPreconds = 42
    PRIMME_SVDS_stats_numGlobalSum = 43
    PRIMME_SVDS_stats_volumeGlobalSum = 44
    PRIMME_SVDS_stats_numBroadcast = 45
    PRIMME_SVDS_stats_volumeBroadcast = 46
    PRIMME_SVDS_stats_numOrthoInnerProds = 47
    PRIMME_SVDS_stats_elapsedTime = 48
    PRIMME_SVDS_stats_timeMatvec = 49
    PRIMME_SVDS_stats_timePrecond = 50
    PRIMME_SVDS_stats_timeOrtho = 51
    PRIMME_SVDS_stats_timeGlobalSum = 52
    PRIMME_SVDS_stats_timeBroadcast = 53
    PRIMME_SVDS_stats_lockingIssue = 54
    PRIMME_SVDS_convTestFun = 55
    PRIMME_SVDS_convTestFun_type = 56
    PRIMME_SVDS_convtest = 57
    PRIMME_SVDS_monitorFun = 58
    PRIMME_SVDS_monitorFun_type = 59
    PRIMME_SVDS_monitor = 60
    PRIMME_SVDS_queue = 61
    PRIMME_SVDS_profile = 62
end

"""
    hprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int hprimme_svds(PRIMME_HALF *svals, PRIMME_HALF *svecs, PRIMME_HALF *resNorms, primme_svds_params *primme_svds);
```
"""
function hprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:hprimme_svds, libprimme), Cint, (Ptr{Float16}, Ptr{Float16}, Ptr{Float16}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    kprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int kprimme_svds(PRIMME_HALF *svals, PRIMME_COMPLEX_HALF *svecs, PRIMME_HALF *resNorms, primme_svds_params *primme_svds);
```
"""
function kprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:kprimme_svds, libprimme), Cint, (Ptr{Float16}, Ptr{_primme_complex_half}, Ptr{Float16}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    sprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int sprimme_svds(float *svals, float *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function sprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:sprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    cprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int cprimme_svds(float *svals, PRIMME_COMPLEX_FLOAT *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function cprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:cprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{ComplexF32}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    dprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int dprimme_svds(double *svals, double *svecs, double *resNorms, primme_svds_params *primme_svds);
```
"""
function dprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:dprimme_svds, libprimme), Cint, (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    zprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int zprimme_svds(double *svals, PRIMME_COMPLEX_DOUBLE *svecs, double *resNorms, primme_svds_params *primme_svds);
```
"""
function zprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:zprimme_svds, libprimme), Cint, (Ptr{Cdouble}, Ptr{ComplexF32}, Ptr{Cdouble}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_hprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_hprimme_svds(PRIMME_HALF *svals, PRIMME_HALF *svecs, PRIMME_HALF *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_hprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_hprimme_svds, libprimme), Cint, (Ptr{Float16}, Ptr{Float16}, Ptr{Float16}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_kprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_kprimme_svds(PRIMME_HALF *svals, PRIMME_COMPLEX_HALF *svecs, PRIMME_HALF *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_kprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_kprimme_svds, libprimme), Cint, (Ptr{Float16}, Ptr{_primme_complex_half}, Ptr{Float16}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_sprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_sprimme_svds(float *svals, float *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_sprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_sprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{Cfloat}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_cprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_cprimme_svds(float *svals, PRIMME_COMPLEX_FLOAT *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_cprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_cprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{ComplexF32}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_dprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_dprimme_svds(double *svals, double *svecs, double *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_dprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_dprimme_svds, libprimme), Cint, (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_zprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_zprimme_svds(double *svals, PRIMME_COMPLEX_DOUBLE *svecs, double *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_zprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_zprimme_svds, libprimme), Cint, (Ptr{Cdouble}, Ptr{ComplexF32}, Ptr{Cdouble}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    hsprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int hsprimme_svds(float *svals, PRIMME_HALF *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function hsprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:hsprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{Float16}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    ksprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int ksprimme_svds(float *svals, PRIMME_COMPLEX_HALF *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function ksprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:ksprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{_primme_complex_half}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_hsprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_hsprimme_svds(float *svals, PRIMME_HALF *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_hsprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_hsprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{Float16}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    magma_ksprimme_svds(svals, svecs, resNorms, primme_svds)


### Prototype
```c
int magma_ksprimme_svds(float *svals, PRIMME_COMPLEX_HALF *svecs, float *resNorms, primme_svds_params *primme_svds);
```
"""
function magma_ksprimme_svds(svals, svecs, resNorms, primme_svds)
    ccall((:magma_ksprimme_svds, libprimme), Cint, (Ptr{Cfloat}, Ptr{_primme_complex_half}, Ptr{Cfloat}, Ptr{primme_svds_params}), svals, svecs, resNorms, primme_svds)
end

"""
    primme_svds_params_create()


### Prototype
```c
primme_svds_params * primme_svds_params_create(void);
```
"""
function primme_svds_params_create()
    ccall((:primme_svds_params_create, libprimme), Ptr{primme_svds_params}, ())
end

"""
    primme_svds_params_destroy(primme_svds)


### Prototype
```c
int primme_svds_params_destroy(primme_svds_params *primme_svds);
```
"""
function primme_svds_params_destroy(primme_svds)
    ccall((:primme_svds_params_destroy, libprimme), Cint, (Ptr{primme_svds_params},), primme_svds)
end

"""
    primme_svds_initialize(primme_svds)


### Prototype
```c
void primme_svds_initialize(primme_svds_params *primme_svds);
```
"""
function primme_svds_initialize(primme_svds)
    ccall((:primme_svds_initialize, libprimme), Cvoid, (Ref{primme_svds_params},), primme_svds)
end

"""
    primme_svds_set_method(method, methodStage1, methodStage2, primme_svds)


### Prototype
```c
int primme_svds_set_method(primme_svds_preset_method method, primme_preset_method methodStage1, primme_preset_method methodStage2, primme_svds_params *primme_svds);
```
"""
function primme_svds_set_method(method, methodStage1, methodStage2, primme_svds)
    ccall((:primme_svds_set_method, libprimme), Cint, (primme_svds_preset_method, primme_preset_method, primme_preset_method, Ptr{primme_svds_params}), method, methodStage1, methodStage2, primme_svds)
end

"""
    primme_svds_display_params(primme_svds)


### Prototype
```c
void primme_svds_display_params(primme_svds_params primme_svds);
```
"""
function primme_svds_display_params(primme_svds)
    ccall((:primme_svds_display_params, libprimme), Cvoid, (primme_svds_params,), primme_svds)
end

"""
    primme_svds_free(primme_svds)


### Prototype
```c
void primme_svds_free(primme_svds_params *primme_svds);
```
"""
function primme_svds_free(primme_svds)
    ccall((:primme_svds_free, libprimme), Cvoid, (Ptr{primme_svds_params},), primme_svds)
end

"""
    primme_svds_get_member(primme_svds, label, value)


### Prototype
```c
int primme_svds_get_member(primme_svds_params *primme_svds, primme_svds_params_label label, void *value);
```
"""
function primme_svds_get_member(primme_svds, label, value)
    ccall((:primme_svds_get_member, libprimme), Cint, (Ptr{primme_svds_params}, primme_svds_params_label, Ptr{Cvoid}), primme_svds, label, value)
end

"""
    primme_svds_set_member(primme_svds, label, value)


### Prototype
```c
int primme_svds_set_member(primme_svds_params *primme_svds, primme_svds_params_label label, void *value);
```
"""
function primme_svds_set_member(primme_svds, label, value)
    ccall((:primme_svds_set_member, libprimme), Cint, (Ptr{primme_svds_params}, primme_svds_params_label, Ptr{Cvoid}), primme_svds, label, value)
end

"""
    primme_svds_member_info(label, label_name, type, arity)


### Prototype
```c
int primme_svds_member_info(primme_svds_params_label *label, const char** label_name, primme_type *type, int *arity);
```
"""
function primme_svds_member_info(label, label_name, type, arity)
    ccall((:primme_svds_member_info, libprimme), Cint, (Ptr{primme_svds_params_label}, Ptr{Ptr{Cchar}}, Ptr{primme_type}, Ptr{Cint}), label, label_name, type, arity)
end

"""
    primme_svds_constant_info(label_name, value)


### Prototype
```c
int primme_svds_constant_info(const char* label_name, int *value);
```
"""
function primme_svds_constant_info(label_name, value)
    ccall((:primme_svds_constant_info, libprimme), Cint, (Ptr{Cchar}, Ptr{Cint}), label_name, value)
end

"""
    primme_svds_enum_member_info(label, value, value_name)


### Prototype
```c
int primme_svds_enum_member_info( primme_svds_params_label label, int *value, const char **value_name);
```
"""
function primme_svds_enum_member_info(label, value, value_name)
    ccall((:primme_svds_enum_member_info, libprimme), Cint, (primme_svds_params_label, Ptr{Cint}, Ptr{Ptr{Cchar}}), label, value, value_name)
end

const PRIMME_VERSION_MAJOR = 3

const PRIMME_VERSION_MINOR = 2

const PRIMME_HALF = Float16

# Skipping MacroDefinition: PRIMME_QUAD double long

# Skipping MacroDefinition: PRIMME_COMPLEX_HALF struct _primme_complex_half

const PRIMME_COMPLEX_FLOAT = ComplexF32 

const PRIMME_COMPLEX_DOUBLE = ComplexF64

# Skipping MacroDefinition: PRIMME_COMPLEX_QUAD long double complex

const PRIMME_INT = Int64

const PRIMME_INT_MAX = typemax(Int64)

const PRIMME_UNEXPECTED_FAILURE = -1

const PRIMME_MALLOC_FAILURE = -2

const PRIMME_MAIN_ITER_FAILURE = -3

const PRIMME_LAPACK_FAILURE = -40

const PRIMME_USER_FAILURE = -41

const PRIMME_ORTHO_CONST_FAILURE = -42

const PRIMME_PARALLEL_FAILURE = -43

const PRIMME_FUNCTION_UNAVAILABLE = -44

end # module
