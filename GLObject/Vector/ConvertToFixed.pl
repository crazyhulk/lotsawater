#!/usr/bin/perl

use strict;
use Regexp::Common;

my $text;
$text.=$_ while <>;

print convert($text);

sub convert($)
{
	my $text=shift;

	$text=convertoperators($text);

	$text=~s!\Q#include <math.h>!#include "Integer.h"!g;
	$text=~s!\Q#include "Vector.h"!#include "VectorFixed.h"!g;
	$text=~s!\Q#include "Matrix.h"!#include "MatrixFixed.h"!g;
	$text=~s!\Q#include "Quaternion.h"!#include "QuaternionFixed.h"!g;

	$text=~s/\Q__VECTOR_H__/__VECTOR_FIXED_H__/g;
	$text=~s/\Q__MATRIX_H__/__MATRIX_FIXED_H__/g;
	$text=~s/\Q__QUATERNION_H__/__QUATERNION_FIXED_H__/g;

	$text=~s/\bfloat a\b/int a/g;
	$text=~s/\bfloat angle\b/int angle/g;
	$text=~s/\bfloat\b/int32_t/g;

	$text=~s/\bsqrtf\b/isqrt/g;
	$text=~s/\bsinf\b/isin/g;
	$text=~s/\bcosf\b/icos/g;
	$text=~s/\btanf\b/itan/g;
	$text=~s/\bacosf\b/iacos/g;
	$text=~s/\bfabsf\b/abs/g;

	$text=~s/\b(?<!\[)1(?!\])\b/F(1)/g;

	$text=~s/\b(vec[2-4][a-z0-9_]*)\b/i$1/g;
	$text=~s/\b(quat[a-z0-9_]*)\b/i$1/g;
	$text=~s/\b(mat[2-4]x[2-4][a-z0-9_]*)\b/i$1/g;

	my @deletedfunctions=qw(imat4x4perspectiveinternal imat4x4horizontalperspective
	imat4x4verticalperspective imat4x4minperspective imat4x4maxperspective
	imat4x4diagonalperspective iquatslerp);

	foreach my $function (@deletedfunctions)
	{
		$text=~s!\n([^\n]*\Q$function\E\s*\([^)]*\)\s*$RE{balanced}{-parens=>"{}"})!\n/*$1*/!;
	}

	return $text;
}

sub convertoperators($)
{
	my $text=shift;

	my $paren_re=$RE{balanced}{-parens=>"()"};
	my $bracket_re=$RE{balanced}{-parens=>"[]"};
	my $left_simple_re=qr{[^\s()\[\],;=+-]{1,64}};
	my $right_simple_re=qr{[^\s()\[\],;=+-]{1,64}};
	my $left_re=qr{(?:$left_simple_re|$paren_re|$bracket_re){1,5}};
	my $right_re=qr{(?:$right_simple_re|$paren_re|$bracket_re){1,5}};
	my $op_re=qr{(?:\*|(?<!/)/)};

	$text=~s:(?<left>$left_re)(?<op>$op_re)(?<right>$right_re):
		my ($left,$op,$right)=($+{left},$+{op},$+{right});

		$left=convertoperators($left);
		$right=convertoperators($right);

		if($left=~/^[0-9]+$/ or $right=~/^[0-9]+$/) { "$left$op$right" }
		elsif($op eq '*') { "imul($left,$right)" }
		else { "idiv($left,$right)" }
	:ges;

	return $text;
}
