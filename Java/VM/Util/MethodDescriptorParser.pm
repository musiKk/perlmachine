package Java::VM::Util::MethodDescriptorParser;

use Carp;
require Exporter;

our @ISA = qw/ Exporter /;
our @EXPORT_OK = qw/ parse_method_descriptor /;

my $SIMPLE_TYPE_PATTERN = qr/[BCDFIJSZ]/;

sub parse_method_descriptor {
	my $descriptor = shift;
	
	unless( $descriptor =~ /\((.*?)\).*/ ) {
		confess 'malformed method descriptor: ', $descriptor, "\n";
	}
	
	my $signature = $1;
	
	my @types = ();
	
	while(1) {
		last unless $signature;
		push @types, _parse_next_type( \$signature );
	}
	
	@types;
}

sub _parse_next_type {
	my $signature = shift;
	
	my $char = substr $$signature, 0, 1, '';
	if( $char =~ $SIMPLE_TYPE_PATTERN ) {
		return $char;
	}
	if( $char eq '[' ) {
		return '[' . _parse_array( $signature );
	}
	if( $char eq 'L' ) {
		return 'L' . _parse_reference( $signature );
	}
}

sub _parse_array {
	my $signature = shift;
	_parse_next_type( $signature );
}

sub _parse_reference {
	my $signature = shift;
	
	$$signature =~ s/^(.*?;)//;
	$1;
}
