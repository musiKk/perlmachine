package Java::VM::ArrayVariable;

use Moose;

use Java::VM::Variable;

extends 'Java::VM::Variable';

has length => (
	is			=> 'ro',
	isa			=> 'Num',
	required	=> 1
);

has '+value' => (
	is		=> 'rw',
	isa		=> 'ArrayRef',
	default	=> sub { [] }
);

sub BUILD {
	my $self = shift;
	my $descriptor = $self->descriptor;
	
	if( $descriptor =~ /\[[\[L]/ ) {
		for(1..$self->length) {
			push @{$self->value}, $Java::VM::NULL_INSTANCE;
		}
	} else {
		for(1..$self->length) {
			push @{$self->value}, 0;
		}
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
