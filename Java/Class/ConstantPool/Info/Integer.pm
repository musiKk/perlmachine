package Java::Class::ConstantPool::Info::Integer;

use Moose;

extends 'Java::Class::ConstantPool::Info';

has 'value' => (
	is		=> 'ro',
	isa		=> 'Num',
	writer	=> '_value'
);

sub BUILD {
	my $self = shift;
	
	$self->_value( $self->reader->read_u4 );
}

no Moose;

__PACKAGE__->meta->make_immutable;
