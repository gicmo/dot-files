use strict;
use Irssi;

use vars qw($VERSION %IRSSI);

$VERSION = "1.10";
%IRSSI = (
    authors     => 'Christian Kellner',
    contact     => 'christian@kellner.me',
    name        => 'pw.pl',
    description => 'Simple external pw managment',
    license     => 'GPLv2',
    url         => 'https://github.com/gicmo/dot-files'
);

my %auth = ();

sub cmd_pw_load {
    my $file = Irssi::get_irssi_dir()."/auth.secret";
    if (open(my $fh, "<", $file)) {
	%auth = ();
	while (<$fh>) {
	    chomp;
	    my ($net, $u, $p, $n) = split(/:/, $_, 4);
	    $auth{$net}{user} = $u;
	    $auth{$net}{password} = $p;
	    $auth{$net}{nick} = $n;
	}
	close($fh);
	Irssi::print("PW: pw manager $VERSION, auth loaded from '$file'");
    }
}

sub cmd_pw_show {

    my $net;
    my $count = 0;

    foreach $net (keys %auth) {
	Irssi::print("PW: $net: [$auth{$net}{user}] *");
	$count++;
    }

    Irssi::print("PW: no networks defined") if !$count;
}

sub cmd_pw {
    my ($data, $server, $item) = @_;

    if ($data ne '') {
	Irssi::command_runsub ('pw', $data, $server, $item);
    } else {
	cmd_sasl_show(@_);
    }
}

# signals ...
sub server_connected {
	my $server = shift;
	if (uc $server->{chat_type} eq 'IRC') {
	    my $net = $server->{chatnet};
	    my $auth = "$auth{$net}{user}/$auth{$net}{nick}:$auth{$net}{password}";
	    Irssi::print("PW: Sending pass for $net ($auth)");
	    $server->send_raw_now("PASS $auth");
	}
}


Irssi::command_bind('pw', \&cmd_pw);
Irssi::command_bind('pw load', \&cmd_pw_load);
Irssi::command_bind('pw show', \&cmd_pw_show);

cmd_pw_load();
cmd_pw_show();

Irssi::signal_add_first('server connected', \&server_connected);
