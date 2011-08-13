package Java::Class::ConstantPool::Info::String;

use Moose;

extends 'Java::Class::ConstantPool::Info';

has 'string_index' => (
	is		=> 'ro',
	isa		=> 'Int',
	writer	=> '_string_index'
);

sub BUILD {
	my $self = shift;
	$self->_string_index( $self->reader->read_u2 );
}

no Moose;

__PACKAGE__->meta->make_immutable;
