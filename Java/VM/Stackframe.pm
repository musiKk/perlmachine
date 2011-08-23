package Java::VM::Stackframe;

use Moose;

use Java::Class;
use Java::Class::Methods::Method;
use Java::VM::Variable;
use Java::VM::Util::MethodDescriptorParser qw/ parse_method_descriptor /;

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

# if this stack frame is pushed onto the stack, the instruction index is
# the index of the code array where execution left
has instruction_index => (
	is		=> 'rw',
	isa		=> 'Int',
	default	=> 0
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

# This is a stupid implementation detail of the interpreter:
# If this is set and the current method is done, the interpreter will return
# from the sub executing the main loop after popping the stack rather than
# continuing. This allows to have code executed in the midst of an instruction
# like static initializers and creating string instances from literals.
has return_control => (
	is			=> 'ro',
	isa			=> 'Bool',
	default		=> 0
);

# parses the given method descriptor, takes the appropriate variables from the
# operand stack of $stack_frame and sets those to the variables of $self
sub fill_variables {
	my $self = shift;
	my $method_descriptor = shift;
	my $stack_frame = shift;
	my $static = shift;
	
	my @types = parse_method_descriptor( $method_descriptor );
	my @variables = ();
	for my $type ( reverse @types ) {
		# maybe check for correct types
		my $var = $stack_frame->pop_op;
		unshift @variables, $var;
	}
	
	my $current_variable_index;
	if( $static ) {
		$current_variable_index = 0;
	} else {
		$current_variable_index = 1;
		$self->variables->[0] = $stack_frame->pop_op;
	}
	
	for my $variable ( @variables ) {
		$self->variables->[$current_variable_index++] = $variable;
		if( $variable->descriptor =~ /[DJ]/ ) {
			# double and long variables take up two places in the local
			# variables array
			$current_variable_index++;
		}
	}
}

sub increment_instruction_index {
	my $self = shift;
	$self->instruction_index( $self->instruction_index + 1 );
}

sub dump_stack {
	my $self = shift;
	my $stack = $self->operand_stack;
	
	print "--- dumping stack\n";
	for(reverse @$stack) {
		print ' - ', $_, "\n";
	}
	print "---\n";
}

sub dump_vars {
	my $self = shift;
	my $vars = $self->variables;
	
	print "--- dumping vars\n";
	for(@$vars) {
		print ' - ', $_, "\n";
	}
	print "---\n";
}

no Moose;

__PACKAGE__->meta->make_immutable;
