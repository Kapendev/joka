// A one-file runtime thing I made while testing runtime things.
// Don't use it!!!

module object;

alias noreturn  = typeof(*null);
alias size_t    = typeof(void.sizeof);
alias ptrdiff_t = typeof(cast(void*)0 - cast(void*)0);
alias string    = immutable(char)[];
alias wstring   = immutable(wchar)[];
alias dstring   = immutable(dchar)[];

private {
    version (D_BetterC) {
    } else {
        extern(C) int _Dmain(char[][] args);

        extern(C)
        int main(int argc, char** argv) {
            static char[][256] sliceBuffer = void;

            foreach (i; 0 .. argc) {

            }
            return _Dmain(null);
        }
    }
}

// The `==` operator for slices.
bool __equals(T1, T2)(scope const(T1)[] lhs, scope const(T2)[] rhs) {
    if (lhs.length != rhs.length) return false;
    foreach (i; 0 .. lhs.length) if (lhs[i] != rhs[i]) return false;
    return true;
}

// The `~=` operator for slices. It does nothing in this runtime.
@trusted
ref Array _d_arrayappendT(Array : T[], T)(return ref scope Array x, scope Array y) {
    return x;
}
