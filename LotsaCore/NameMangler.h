#ifndef MangleClassName

#ifdef ClassNamePrefix
#define __Combine1(A,B) A##B
#define __Combine2(A,B) __Combine1(A,B)
#define MangleClassName(ClassName) __Combine2(ClassNamePrefix,ClassName)
#else
#define MangleClassName(ClassName) ClassName
#endif

#endif

