#!/usr/bin/perl

use strict;
use Regexp::Common;

my $text;
$text.=$_ while <>;

print convert($text);

sub convert($)
{
	my $text=shift;

	$text=~s/\Q#include "Vector.h"/#include "VectorDouble.h"/g;
	$text=~s/\Q#include "Matrix.h"/#include "MatrixDouble.h"/g;
	$text=~s/\Q#include "Quaternion.h"/#include "QuaternionDouble.h"/g;

	$text=~s/\Q__VECTOR_H__/__VECTOR_DOUBLE_H__/g;
	$text=~s/\Q__MATRIX_H__/__MATRIX_DOUBLE_H__/g;
	$text=~s/\Q__QUATERNION_H__/__QUATERNION_DOUBLE_H__/g;

	$text=~s/\bfloat\b/double/g;

	$text=~s/\bsqrtf\b/sqrt/g;
	$text=~s/\bsinf\b/sin/g;
	$text=~s/\bcosf\b/cos/g;
	$text=~s/\btanf\b/tan/g;
	$text=~s/\bacosf\b/acos/g;
	$text=~s/\bfabsf\b/fabs/g;

	$text=~s/\b(vec[2-4][a-z0-9_]*)\b/d$1/g;
	$text=~s/\b(quat[a-z0-9_]*)\b/d$1/g;
	$text=~s/\b(mat[2-4]x[2-4][a-z0-9_]*)\b/d$1/g;

	return $text;
}

