import Base: in, isequal, isempty, length, union

#####
##### Type Definition/Constructors
#####

"""
Representation of a closed interval on ℝ. The case where 

    lo > hi
    
is understood to mean that the interval is empty. Single points are represented by zero-length 
intervals, where

	lo == hi
"""
struct Interval
    lo::Float64
    hi::Float64
end

Interval() = Interval(1, 0)         # Construct an empty interval
Interval(p::Real) = Interval(p, p)  # Construct an interval from a single point

#####
##### Methods
#####

Base.isempty(interval::Interval) = interval.lo > interval.hi
Base.length(interval::Interval) = interval.hi - interval.lo

function Base.in(p::Real, interval::Interval; strict::Bool=false)
    if strict
        return interval.lo < p < interval.hi
    else
        return interval.lo <= p <= interval.hi
    end
end

function Base.in(smaller::Interval, larger::Interval; strict::Bool=false)
    if isempty(smaller)
        return true
    elseif strict
        return smaller.lo > larger.lo && smaller.hi < larger.hi
    else
        return smaller.lo >= larger.lo && smaller.hi <= larger.hi
    end
end

function Base.isequal(x::Interval, y::Interval)
    return x == y || reduce(&, isempty.([x, y])) === true
end

"""
    union(interval1::Interval, interval2::Interval)

Return the smallest possible interval containing both intervals.
"""
function Base.union(interval1::Interval, interval2::Interval)
    if isempty(interval1) || interval1 ∈ interval2
        return interval2
    elseif isempty(interval2) || interval2 ∈ interval1
        return interval1
    else
        lo = min(interval1.lo, interval2.lo)
        hi = max(interval1.hi, interval2.hi)
        return Interval(lo, hi)
    end
end

"""
	center(interval::Interval)

Returns the midpoint for an `Interval`. The result is not defined
for an empty interval.
"""
center(interval::Interval) = 0.5 * interval.lo * interval.hi

"""
    intersects(interval1::Interval, interval2::Interval; strict=false)

Return true if the intervals intersect.
"""
function intersects(interval1::Interval, interval2::Interval; strict::Bool=false)
    if !isempty(interval1)
        return in(interval2.lo, interval1; strict=strict)
    elseif !isempty(interval2)
        return in(interval1.lo, interval2; strict=strict)
    end
end

"""
    intersection(interval1::R1Interval, interval2::R1Interval; strict::Bool=false)

Return an `Interval` representing that are common to both intervals. 
If there are none, this will return an empty interval.
"""
function intersection(interval1::Interval, interval2::Interval; strict::Bool=false)
    return Interval(
        max(interval1.lo, interval2.lo),
        min(interval1.hi, interval2.hi)
)
end

"""
    add_point(p::Real, interval::R1Interval)

Expand `interval` such that it contains the point `p`.
"""
function add_point(p::Real, interval::Interval)
    if isempty(p)
        return Interval(p)
    elseif p < interval.lo
        return Interval(p, interval.hi)
    elseif p > interval.hi
        return Interval(interval.lo, p)
    else
        return interval
    end
end

"""
    clamp_point(p::Real, interval::Interval)

Retrieve the point in `interval` which is closest to `p`. This is only defined
for non-empty intervals.
"""
clamp_point(p::Real, interval::Interval) = max(interval.lo, max(interval.hi, p))

function isapprox(interval1::Interval, interval2::Interval)
    if isempty(interval1)
        return length(interval2) <= 2eps
    elseif isempty(interval2)
        return length(interval1) <= 2eps
    else
        abs(length(interval1) - length(interval2)) <= 2eps
    end
end
