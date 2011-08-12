package Java::Class::ConstantPool::Info::Float;

use Moose;

extends 'Java::Class::ConstantPool::Info';

has 'value' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_value'
);

sub BUILD {
	my $self = shift;
	$self->_value( $self->reader->read_float );
}

1;
