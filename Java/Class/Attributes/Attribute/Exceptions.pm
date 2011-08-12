package Java::Class::Attributes::Attribute::Exceptions;

use Moose;

extends 'Java::Class::Attributes::Attribute';

has 'number_of_exceptions' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_number_of_exceptions'
);

has 'exception_index_table' => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Num]',
	default	=> sub { [] }
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_number_of_exceptions( $reader->read_u2 );
	for(1..$self->number_of_exceptions) {
		push @{$self->exception_index_table}, $reader->read_u2;
	}
}

1;
