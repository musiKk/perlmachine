package Java::VM::Variable;

use feature qw/ switch /;
use overload '""' => \&stringify;

use Moose;

has value => (
	is			=> 'rw'
	# yay, we are super dynamic, no 'isa'
);

has descriptor => (
	is			=> 'ro',
	isa			=> 'Str',
	required	=> 1
);

# this is the default for a field variable
sub get_default {
	my $self = shift;
	
	my $descriptor = $self->descriptor;
	my $value;
	given( $descriptor ) {
		when ('B') { $value = 0 }
		when ('C') { $value = 0 }
		when ('D') { $value = 0.0 }
		when ('F') { $value = 0.0 }
		when ('I') { $value = 0 }
		when ('J') { $value = 0 }
		when ('S') { $value = 0 }
		when (/^L/) { $value = $Java::VM::NULL_INSTANCE }
		when ('Z') { $value = 0 }
		when (/^\[/) { $value = $Java::VM::NULL_INSTANCE }
	}
}

sub set_default {
	my $self = shift;
	
	$self->value( $self->get_default );
}

sub stringify {
	my $self = shift;
	$self->descriptor . ': ' . $self->value;
}

# factory methods

sub instance_variable {
	my $instance = shift;
	if( ! $instance->null ) {
		__PACKAGE__->new( descriptor => 'L' . $instance->class->class->get_name . ';', value => $instance );
	} else {
		__PACKAGE__->new( descriptor => '', value => $instance );
	}
}

sub byte_variable {
	my $value = shift;
	__PACKAGE__->new( descriptor => 'B', value => $value );
}

sub short_variable {
	my $value = shift;
	__PACKAGE__->new( descriptor => 'S', value => $value );
}

sub int_variable {
	my $value = shift;
	__PACKAGE__->new( descriptor => 'I', value => $value );
}

sub float_variable {
	my $value = shift;
	__PACKAGE__->new( descriptor => 'F', value => $value );
}

sub long_variable {
	my $value = shift;
	__PACKAGE__->new( descriptor => 'J', value => $value );
}

sub double_variable {
	my $value = shift;
	__PACKAGE__->new( descriptor => 'D', value => $value );
}

sub array_variable {
	my $length = shift;
	my $type = shift;
	
	my $descriptor;
	given( $type ) {
		when (/^[\[L]/) { $descriptor = $type } # reference type
		when (4) { $descriptor = 'Z' } # boolean
		when (5) { $descriptor = 'C' } # char
		when (6) { $descriptor = 'F' } # float
		when (7) { $descriptor = 'D' } # double
		when (8) { $descriptor = 'B' } # byte
		when (9) { $descriptor = 'S' } # short
		when (10) { $descriptor = 'I' } # integer
		when (11) { $descriptor = 'J' } # long
		default { warn "invalid array type: $type" }
	};
	Java::VM::ArrayVariable->new(
		descriptor	=> '[' . $descriptor,
		value		=> [],
		length		=> $length );
}

no Moose;

__PACKAGE__->meta->make_immutable;

=pod

=head1 NAME

Java::VM::Variable - A variable in the VM (a name-value-type tuple).

=head1 SYNOPSIS

=head1 DESCRIPTION

A variable has a value, a descriptor like C<I>, C<[B> or
C<Ljava/util/String;> and optionally a name.

Following is the encoding of values by type:

byte (B):
char (C):
double (D):
float (F):
int (I):
long (J):
short (S):
	what they are in perl

reference (L...;):
	a Java::VM::Instance

boolean (Z):
	0 - false
	1 - true

array ([):
	currently unsupported

=cut
