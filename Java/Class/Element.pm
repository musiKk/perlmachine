package Java::Class::Element;

use Moose;

has 'reader' => (
	is			=> 'ro',
	isa			=> 'Java::Class::Reader',
	required	=> 1
);

1;
