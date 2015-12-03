import std.stdio;
import std.typecons;
import std.functional;

Nullable!T nullable(T)(T val)
{
    return Nullable!T(val);
}

template map(alias fun)
{
    auto map(TT: Nullable!T, T)(TT t)
    {
        alias _fun = unaryFun!fun;
        Nullable!(typeof(_fun(t.get))) result;
        if(!t.isNull) {
            result = nullable(_fun(t.get));
        }
        return result;
    }
}

unittest
{
    struct Hoge { int A; }

    auto a = nullable(Hoge(0)).map!(a => a.A);
    assert(!a.isNull);
    assert(a == 0);

    auto b = nullable(0).map!("a");
    assert(!b.isNull);
    assert(b == 0);

    auto c = Nullable!int().map!("a");
    assert(c.isNull);
}

auto getOrElse(TT: Nullable!T, R, T)(TT nullable, R val)
{
    if(!nullable.isNull) {
        return nullable.get;
    } else {
        return val;
    }
}

unittest
{
    auto a = nullable(0).getOrElse(10);
    assert( a == 0 );
    assert( typeof(a).stringof == "int" );

    auto b = Nullable!string().getOrElse("hoge");
    assert( b == "hoge" );
    assert( typeof(b).stringof == "string" );

    auto z = nullable(5000000000L).getOrElse(0L);
    assert( typeof(z).stringof == "long" );

    auto y = nullable(0L).getOrElse(9000000000L);
    assert( typeof(y).stringof == "long" );

    auto x = nullable(-1).getOrElse(3000000000U);
    assert( typeof(x).stringof == "int" ); // !?

    auto w = Nullable!uint().getOrElse(3000000000U);
    assert( typeof(w).stringof == "uint" );

    class A {}
    class B : A {}

    auto c = getOrElse(Nullable!A(new A), new B);
    assert( typeof(c).stringof == "A" );

    auto d = getOrElse(Nullable!B(new B), new A);
    assert( typeof(d).stringof == "A" );

    auto e = getOrElse(Nullable!A(), new B);
    assert( typeof(e).stringof == "A" );

    auto f = getOrElse(Nullable!B(), new A);
    assert( typeof(f).stringof == "A" );
}

auto orElse(TT: Nullable!T, T)(TT nullable, TT val)
{
    if(!nullable.isNull) {
        return nullable;
    } else {
        return val;
    }
}

unittest
{
    auto a = nullable(0).orElse(nullable(10));
    assert( a == 0 );
    assert( typeof(a).stringof == "Nullable!int");

    auto b = Nullable!int().orElse(nullable(10));
    assert( b == 10 );
    assert( typeof(b).stringof == "Nullable!int");

    auto c = Nullable!int().orElse(Nullable!int());
    assert( c.isNull );
    assert( typeof(c).stringof == "Nullable!int");
}
