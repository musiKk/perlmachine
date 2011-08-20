package Java::VM::ArrayVariable;

use Moose;

extends 'Java::VM::Variable';

has length => (
	is			=> 'ro',
	isa			=> 'Num',
	required	=> 1
);

no Moose;

__PACKAGE__->meta->make_immutable;
