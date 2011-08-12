package Java::Class::Attributes::Attribute::Code::ExceptionTable;

use Moose;

extends 'Java::Class::Element';

has 'start_pc' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_start_pc'
);

has 'end_pc' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_end_pc'
);

has 'handler_pc' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_handler_pc'
);

has 'catch_type' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_catch_type'
);

sub BUILD {
	my $self = shift;
	my $reader = $self->reader;
	
	$self->_start_pc( $reader->read_u2 );
	$self->_end_pc( $reader->read_u2 );
	$self->_handler_pc( $reader->read_u2 );
	$self->_catch_type( $reader->read_u2 );
}

1;
