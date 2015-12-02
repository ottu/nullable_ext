import std.stdio;
import std.typecons;

Nullable!T nullable(T)(T val)
{
    return Nullable!T(val);
}

Nullable!R map(TT : Nullable!T, RR : R function(T), T, R)(TT nullable, RR fn)
{
    typeof(return) result;
    if(!nullable.isNull) {
        result = fn(nullable.get);
    }
    return result;
}

unittest
{
    struct Hoge { int A; }

    auto b = nullable(Hoge(0)).map( (Hoge a) => a.A );
    assert(!b.isNull);

    auto c = Nullable!int().map( (int a) => a );
    assert(c.isNull);
}

R getOrElse(TT: Nullable!T, R, T)(TT nullable, R val)
{
    typeof(return) result = val;
    if(!nullable.isNull) {
        result = nullable.get;
    }
    return result;
}

unittest
{
    auto d = nullable(0).getOrElse(10);
    assert( d == 0 );
    assert( typeof(d).stringof == "int" );

    auto e = Nullable!string().getOrElse("null");
    assert( e == "null" );
    assert( typeof(e).stringof == "string" );
}

TT orElse(TT: Nullable!T, T)(TT nullable, TT val)
{
    typeof(return) result = val;
    if(!nullable.isNull) {
        result = nullable;
    }
    return result;
}

unittest
{
    auto f = nullable(0).orElse(Nullable!int(10));
    assert( f == 0 );
    assert( typeof(f).stringof == "Nullable!int");

    auto g = Nullable!int().orElse(Nullable!int(10));
    assert( g == 10 );
    assert( typeof(g).stringof == "Nullable!int");
}
