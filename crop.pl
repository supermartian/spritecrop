#!/usr/bin/perl -w

use strict;
use GD;
use Getopt::Long;

my $cropwidth;
my $cropheight;
my $width;
my $height;
my $srcfile;
GetOptions ("src=s" => \$srcfile,
            "width=i" => \$cropwidth,
            "height=i" => \$cropheight)
    or die("Wrong arguments.");

if (!$srcfile || !$cropwidth || !$cropheight) {
    die("Shit happened on arguments");
}

my $image = GD::Image->new($srcfile) or die "Cannot open $srcfile";
($width, $height) = $image->getBounds();

if ($width < $cropwidth || $height < $cropheight) {
    die("Crop dimenson is not correct.");
}

my $x = 0;
my $y = 0;
my $count = 0;
my $x_count = $width / $cropwidth;
my $y_count = $height / $cropheight;
my $outimg = GD::Image->new($cropwidth, $cropheight);

while ($y_count) {
    $outimg->copy($image, 0, 0, $x, $y, $cropwidth, $cropheight);

    open(IMG, "+>", "$count\_$srcfile") or die "Cannot open it.";
    binmode IMG;
    print IMG $outimg->png;
    close IMG;

    $count++;

    $x += $cropwidth;
    if ($x >= $width) {
        $y += $cropheight;
        $x = 0;
        $y_count --;
    }
}
