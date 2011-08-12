package Java::VM::Stackframe;

use Moose;

use Java::VM::Variable;
use Java::Class;
use Java::Class::Methods::Method;

has variables => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Java::VM::Variable]',
	default	=> sub { [] }
);

has operand_stack => (
	is		=> 'ro',
	isa		=> 'ArrayRef[Java::VM::Variable]',
	traits	=> [ 'Array' ],
	default	=> sub { [] },
	handles	=> { push_op => 'push', pop_op => 'pop' }
);

# if this stack frame is pushed onto the stack, the return instruction index is
# the index of the code array where execution left
has return_instruction_index => (
	is		=> 'rw',
	isa		=> 'Int'
);

has method => (
	is			=> 'ro',
	isa			=> 'Java::Class::Methods::Method',
	required	=> 1
);

has class => (
	is			=> 'rw',
	isa			=> 'Java::VM::LoadedClass',
	required	=> 1
);

no Moose;

__PACKAGE__->meta->make_immutable;
