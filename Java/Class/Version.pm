package Java::Class::Version;

use Moose;

use overload '""' => \&to_string;

extends 'Java::Class::Element';

has 'minor' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_minor'
);

has 'major' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_major'
);

sub BUILD {
	my $self = shift;
	$self->_minor( $self->reader->read_u2 );
	$self->_major( $self->reader->read_u2 );
}

sub to_string {
	my $self = shift;
	return $self->major . '.' . $self->minor;
}

1;
