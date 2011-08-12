package Java::Class::Interfaces;

use Moose;

extends 'Java::Class::Element';

has 'count' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_count'
);

has 'interfaces' => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Num]',
	writer	=> '_interfaces',
	default	=> sub { [] }
);

sub get {
	my ($self, $index) = @_;
	return @{$self->_interfaces}[$index];
}

sub BUILD {
	my $self = shift;
	
	$self->_count( $self->reader->read_u2 );
	for(1..$self->count) {
		push @{$self->_interfaces}, $self->reader->read_u2;
	}
}

1;
