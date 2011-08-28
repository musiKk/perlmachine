package Java::Class::ElementWithCp;

use Moose;

extends 'Java::Class::Element';

has 'constant_pool' => (
	is			=> 'ro',
	isa			=> 'Java::Class::ConstantPool',
	required	=> 1
);

no Moose;

__PACKAGE__->meta->make_immutable;
