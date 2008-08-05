#!/usr/bin/perl

use CGI qw/:all/;

my $q = new CGI;
my $cgiresp = "";
my $tmpdir = '/tmp';

if ($q->request_method() eq "POST") {
	my $pathToGnuGo = '/usr/bin/gnugo';

	my $wCmds = "$tmpdir/.whiteCmds.gtp";
	my $bCmds = "$tmpdir/.blackCmds.gtp";

	my $inFileData = $q->param('sgf');
	my $moveFor = $q->param('player');
	my $level = $q->param('level') || 5;

	if ($inFileData && $moveFor && $level < 12) {
		my $tsgf = "$tmpdir/uGo-GnuGoBride.temporary.".time().".sgf";
		open (TSGF, "+>$tsgf") or die "Unable to write SGF file '$tsgf': $!\n\n";
		print TSGF $inFileData;
		close TSGF;

		if (!(-e $wCmds)) {
			open (WC, "+>$wCmds");
			print WC "genmove white\r\n";
			close (WC);
		}

		if (!(-e $bCmds)) {
			open (BC, "+>$bCmds");
			print BC "genmove black\r\n";
			close (BC);
		}

		my $cmd = "$pathToGnuGo --mode gtp -l \"$tsgf\" --level $level --gtp-input \"" . ($moveFor eq "white" ? $wCmds : $bCmds) . "\"";
		my $resp = `$cmd`;

		if ($resp =~ /^=\s+(\w\d+)/) {
			$cgiresp .= "$1";
		}
		else {
			$cgiresp .= "Incorrect response: \"$resp\"";
		}

		unlink($tsgf);
		unlink($wCmds);
		unlink($bCmds);
	}
	else {
		$cgiresp = $level < 12 ? "Not enough information provided." : "Given play level was too high.";
	}
}
else
{
	$cgiresp = "Incorrect HTTP method.";
}

print $q->header();
print $cgiresp;
