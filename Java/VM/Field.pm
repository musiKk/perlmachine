package Java::VM::Field;

use Moose;

use Java::Class::Fields::Field;
use Java::VM::Variable;

has field => (
	is			=> 'ro',
	isa			=> 'Java::Class::Fields::Field',
	required	=> 1
);

has value => (
	is			=> 'rw',
	isa			=> 'Java::VM::Variable'
);

no Moose;

__PACKAGE__->meta->make_immutable;
