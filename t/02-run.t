#!/usr/bin/env perl6

use v6;

use lib "{$*PROGRAM.dirname}/../lib";
use lib "{$*PROGRAM.dirname}/../../perl6-wiringpi/lib";

use RPi::Wiring::Pi;
use RPi::Wiring::SPI;
use RPi::Device::ST7036;

my $res = wiringPiSetup;
die if $res != 0;

wiringPiSPISetup 0, 1_000_000;
wiringPiSPISetup 1, 1_000_000;



my RPi::Device::ST7036 $lcd .= new(
    rs-pin      => 25,
    spi-channel => 1,
    setup       => RPi::Device::ST7036::Setup.DOGM081_3_3V,
    cursor      => True,
    cursorBlink => True,
    contrast    => 0b010000
);

$lcd.init;

$lcd.write: '!!Yow!!!';
say "!!YoY!!!";

#`(
say ">> fill screen";
for ^8 -> $i {
    $lcd.set-cursor-offset: $i;
    sleep .05;
    $lcd.write: chr($i + 65);
    sleep .02;
}
say ">> cycle character set";
for ^( 256 - 8 ) -> $i {
    $lcd.set-cursor-offset: 0x00;
    $lcd.write(($i .. $i + 8).map( *.chr ).join);
    sleep .02;
    $lcd.clear;
}
$lcd.clear;

say ">> test contrast range";
$lcd.set-cursor-offset: 0x10;
$lcd.write: "test contrast";
for 0 .. 0x40 -> $i {
    $lcd.set-contrast: $i;
    sleep 0.02;
}
for 0x40 ... 0 -> $i {
    $lcd.set-contrast: $i;
    sleep 0.02;
}
    
$lcd.set-contrast: 40;
$lcd.clear;

say ">> test set cursor position";
for ^50 {
    my $row = 0;
    my $col = 8.rand.floor;

    $lcd.set-cursor-position: $col, $row;
    $lcd.write: 'o';
    sleep .10;
    $lcd.set-cursor-position: $col, $row;
    $lcd.write: ' ';
}
)

