FIXED_C_FILES = VectorFixed.c MatrixFixed.c QuaternionFixed.c
FIXED_H_FILES = VectorFixed.h MatrixFixed.h QuaternionFixed.h
DOUBLE_C_FILES = VectorDouble.c MatrixDouble.c QuaternionDouble.c
DOUBLE_H_FILES = VectorDouble.h MatrixDouble.h QuaternionDouble.h
COMPLEX_C_FILES = VectorComplex.c MatrixComplex.c
COMPLEX_H_FILES = VectorComplex.h MatrixComplex.h
COMPLEX_DOUBLE_C_FILES = VectorComplexDouble.c MatrixComplexDouble.c
COMPLEX_DOUBLE_H_FILES = VectorComplexDouble.h MatrixComplexDouble.h

ALL_FILES =	$(FIXED_C_FILES) $(FIXED_H_FILES) \
		$(DOUBLE_C_FILES) $(DOUBLE_H_FILES) \
		$(COMPLEX_C_FILES) $(COMPLEX_H_FILES) \
		$(COMPLEX_DOUBLE_C_FILES) $(COMPLEX_DOUBLE_H_FILES)

all: $(ALL_FILES)

clean:
	rm -f $(ALL_FILES)

$(FIXED_C_FILES): %Fixed.c: %.c ConvertToFixed.pl
	perl ConvertToFixed.pl <$< >$@

$(FIXED_H_FILES): %Fixed.h: %.h ConvertToFixed.pl
	perl ConvertToFixed.pl <$< >$@

$(DOUBLE_C_FILES): %Double.c: %.c ConvertToDouble.pl
	perl ConvertToDouble.pl <$< >$@

$(DOUBLE_H_FILES): %Double.h: %.h ConvertToDouble.pl
	perl ConvertToDouble.pl <$< >$@

$(COMPLEX_C_FILES): %Complex.c: %.c ConvertToComplex.pl
	perl ConvertToComplex.pl <$< >$@

$(COMPLEX_H_FILES): %Complex.h: %.h ConvertToComplex.pl
	perl ConvertToComplex.pl <$< >$@

$(COMPLEX_DOUBLE_C_FILES): %ComplexDouble.c: %.c ConvertToComplexDouble.pl
	perl ConvertToComplexDouble.pl <$< >$@

$(COMPLEX_DOUBLE_H_FILES): %ComplexDouble.h: %.h ConvertToComplexDouble.pl
	perl ConvertToComplexDouble.pl <$< >$@
