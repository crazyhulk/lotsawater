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
	$text=~s/\Q#include "Vector.h"/#include "VectorComplex.h"/g;
	$text=~s/\Q#include "Matrix.h"/#include "MatrixComplex.h"/g;

	$text=~s/\Q__VECTOR_H__/__VECTOR_COMPLEX_H__/g;
	$text=~s/\Q__MATRIX_H__/__MATRIX_COMPLEX_H__/g;

	$text=~s/\bfloat\b/complex float/g;
	$text=~s/\bcomplex float epsilon\b/float epsilon/g;

	$text=~s/\bsqrtf\b/csqrtf/g;
	$text=~s/\bsinf\b/csinf/g;
	$text=~s/\bcosf\b/ccosf/g;
	$text=~s/\btanf\b/ctanf/g;
	$text=~s/\bacosf\b/cacosf/g;
	$text=~s/\bfabsf\b/cabsf/g;

	$text=~s/\b(vec[2-4][a-z0-9_]*)\b/c$1/g;
	$text=~s/\b(quat[a-z0-9_]*)\b/c$1/g;
	$text=~s/\b(mat[2-4]x[2-4][a-z0-9_]*)\b/c$1/g;

	my @deletedfunctions=qw(cvec2almostequal cvec3almostequal
	cvec4almostequal cmat2x2almostequal cmat3x2almostequal
	cmat3x3almostequal cmat4x3almostequal cmat4x4almostequal
	cmat4x4minperspective cmat4x4maxperspective);

	foreach my $function (@deletedfunctions)
	{
		$text=~s!\n([^\n]*\Q$function\E\s*\([^)]*\)\s*$RE{balanced}{-parens=>"{}"})!\n/*$1*/!;
	}

	return $text;
}

