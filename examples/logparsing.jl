using Restarts
using StatsBase
using Test

if !@isdefined(Returns)  # Julia < 1.7
    Returns(x) = (_args...; _kwargs...) -> x
end

@define_restart use_value
@define_restart reparse_entry

struct MalformedLogEntryError <: Exception
    text::String
end

function parse_log_entry(text)
    parts = split(text, ":", limit = 2)
    if length(parts) == 2
        return (level = Symbol(strip(parts[1])), text = strip(parts[2]))
    end

    restart(
        MalformedLogEntryError(text),
        use_value => value -> value,  # or `use_value => identity`
        reparse_entry => fixed_text -> parse_log_entry(fixed_text),
    )
end

function test_parse_log_entry()
    @test parse_log_entry("INFO: message") == (level = :INFO, text = "message")
    @test_throws MalformedLogEntryError parse_log_entry("malformed log entry")
    @test Restarts.with(reparse_entry => ex -> Some("_MALFORMED_:" * ex.text)) do
        parse_log_entry("malformed log entry")
    end == (level = :_MALFORMED_, text = "malformed log entry")
end

function countlevels(io::IO)
    Restarts.with(use_value => Returns(Some((level = :_MALFORMED_, text = "")))) do
        countmap(map(t -> parse_log_entry(t).level, eachline(io)))
    end
end

function test_count_levels()
    io = IOBuffer("""
    INFO: message 1
    INFO: message 2
    malformed
    DEBUG: message 2
    """)
    levels = countlevels(io)
    @test levels == Dict(:INFO => 2, :DEBUG => 1, :_MALFORMED_ => 1)
end
