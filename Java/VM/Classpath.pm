package Java::VM::Classpath;

use Moose;

has entries => (
	is		=> 'rw',
	isa		=> 'ArrayRef[Str]',
	traits	=> [ 'Array' ],
	default	=> sub { [] },
	handles	=> { add_entry => 'push' }
);

__PACKAGE__->meta->make_immutable;
