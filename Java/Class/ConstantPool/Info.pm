package Java::Class::ConstantPool::Info;

use Moose;

use feature 'switch';

extends 'Java::Class::Element';

has 'tag' => (
	is			=> 'ro',
	isa			=> 'Int',
	required	=> 1
);

1;
