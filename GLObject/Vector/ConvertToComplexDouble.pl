#!/usr/bin/perl

use strict;
use Regexp::Common;

my $text;
$text.=$_ while <>;

print convert($text);

sub convert($)
{
	my $text=shift;

	$text=~s!\Q#include <math.h>!#include <math.h>\n#include <complex.h>!g;
	$text=~s/\Q#include "Vector.h"/#include "VectorComplexDouble.h"/g;
	$text=~s/\Q#include "Matrix.h"/#include "MatrixComplexDouble.h"/g;

	$text=~s/\Q__VECTOR_H__/__VECTOR_COMPLEX_DOUBLE_H__/g;
	$text=~s/\Q__MATRIX_H__/__MATRIX_COMPLEX_DOUBLE_H__/g;

	$text=~s/\bfloat\b/complex double/g;
	$text=~s/\bcomplex double epsilon\b/double epsilon/g;

	$text=~s/\bsqrtf\b/csqrt/g;
	$text=~s/\bsinf\b/csin/g;
	$text=~s/\bcosf\b/ccos/g;
	$text=~s/\btanf\b/ctan/g;
	$text=~s/\bacosf\b/cacos/g;
	$text=~s/\bfabsf\b/cabs/g;

	$text=~s/\b(vec[2-4][a-z0-9_]*)\b/cd$1/g;
	$text=~s/\b(quat[a-z0-9_]*)\b/cd$1/g;
	$text=~s/\b(mat[2-4]x[2-4][a-z0-9_]*)\b/cd$1/g;

	my @deletedfunctions=qw(cdvec2almostequal cdvec3almostequal
	cdvec4almostequal cdmat2x2almostequal cdmat3x2almostequal
	cdmat3x3almostequal cdmat4x3almostequal cdmat4x4almostequal
	cdmat4x4minperspective cdmat4x4maxperspective);

	foreach my $function (@deletedfunctions)
	{
		$text=~s!\n([^\n]*\Q$function\E\s*\([^)]*\)\s*$RE{balanced}{-parens=>"{}"})!\n/*$1*/!;
	}

	return $text;
}

