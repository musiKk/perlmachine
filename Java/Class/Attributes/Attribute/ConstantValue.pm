package Java::Class::Attributes::Attribute::ConstantValue;

use Moose;

extends 'Java::Class::Attributes::Attribute';

has 'constantvalue_index' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_constantvalue_index'
);

sub BUILD {
	my $self = shift;
	
	$self->_constantvalue_index( $self->reader->read_u2 );
}

1;
