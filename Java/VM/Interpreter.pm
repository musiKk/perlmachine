package Java::VM::Interpreter;

use feature qw/ switch /;

use Moose;

use Java::VM::Bytecode::Decoder;
use Java::VM::LoadedClass;
use Java::VM::Stackframe;

# the following two attributes are just for the constructor
has class => (
	is			=> 'ro',
	isa			=> 'Java::VM::LoadedClass',
	required	=> 1
);

has method => (
	is			=> 'ro',
	isa			=> 'Java::Class::Methods::Method',
	required	=> 1
);
##################

has stack => (
	is			=> 'ro',
	isa			=> 'ArrayRef[Java::VM::Stackframe]',
	traits		=> [ 'Array' ],
	required	=> 1,
	default		=> sub { [] },
	handles		=> {
			push_stack_frame	=> 'push',
			pop_stack_frame		=> 'pop' }
);

my $code_map = Java::VM::Bytecode::Opcode::get_opcodes();

# when run is called, we have exactly one stack frame on our stack: the frame
# for the main method
sub run {
	my $self = shift;
	
	my $instruction_index = 0;
	
	my $stack_frame = $self->_get_last_stack_frame;
	my $method = $stack_frame->method;
	my $class = $stack_frame->class;
	# TODO there should be a code cache for method code
	my $code_array = Java::VM::Bytecode::Decoder::decode( $method->code_raw );
	
	while(1) {
		my $instruction = $code_array->[$instruction_index];
		my $opcode = $instruction->[1];
		
		my $mnemonic = $code_map->{$opcode}->mnemonic;
		given($mnemonic) {
			when('aload_0') {
				push @{$stack_frame->operand_stack}, $stack_frame->variables->[0];
			}
			when('ret') {
				$instruction_index = $instruction->[2];
				next;
			}
			when('return') {
				return if 1 == scalar @{$self->stack}; # the last stack frame - the main
				
				$stack_frame = $self->pop_stack_frame;
				$method = $stack_frame->method;
				$class = $stack_frame->class;
				$instruction_index = $stack_frame->return_instruction_index;
			}
			when('dstore') {
				$stack_frame->variables->[$instruction->[2]] = $stack_frame->pop_op;
			}
			when('dstore_0') {
				$stack_frame->variables->[0] = $stack_frame->pop_op;
			}
			when('dstore_1') {
				$stack_frame->variables->[1] = $stack_frame->pop_op;
			}
			when('dstore_2') {
				$stack_frame->variables->[2] = $stack_frame->pop_op;
			}
			when('dstore_3') {
				$stack_frame->variables->[3] = $stack_frame->pop_op;
			}
			when('fstore') {
				$stack_frame->variables->[$instruction->[2]] = $stack_frame->pop_op;
			}
			when('fstore_0') {
				$stack_frame->variables->[0] = $stack_frame->pop_op;
			}
			when('fstore_1') {
				$stack_frame->variables->[1] = $stack_frame->pop_op;
			}
			when('fstore_2') {
				$stack_frame->variables->[2] = $stack_frame->pop_op;
			}
			when('fstore_3') {
				$stack_frame->variables->[3] = $stack_frame->pop_op;
			}
			when('iconst_m1') {
				$stack_frame->push_op( Java::VM::Variable->int_variable( -1 ) );
			}
			when('iconst_0') {
				$stack_frame->push_op( Java::VM::Variable->int_variable( 0 ) );
			}
			when('iconst_1') {
				$stack_frame->push_op( Java::VM::Variable->int_variable( 1 ) );
			}
			when('iconst_2') {
				$stack_frame->push_op( Java::VM::Variable->int_variable( 2 ) );
			}
			when('iconst_3') {
				$stack_frame->push_op( Java::VM::Variable->int_variable( 3 ) );
			}
			when('iconst_4') {
				$stack_frame->push_op( Java::VM::Variable->int_variable( 4 ) );
			}
			when('iconst_5') {
				$stack_frame->push_op( Java::VM::Variable->int_variable( 5 ) );
			}
			when('istore') {
				$stack_frame->variables->[$instruction->[2]] = $stack_frame->pop_op;
			}
			when('istore_0') {
				$stack_frame->variables->[0] = $stack_frame->pop_op;
			}
			when('istore_1') {
				$stack_frame->variables->[1] = $stack_frame->pop_op;
			}
			when('istore_2') {
				$stack_frame->variables->[2] = $stack_frame->pop_op;
			}
			when('istore_3') {
				$stack_frame->variables->[3] = $stack_frame->pop_op;
			}
			when(['ldc','ldc_w','ldc2_w']) {
				my $info = $stack_frame->class->class->constant_pool->get_info( $instruction->[2] );
				my $tag_name = $Java::Class::ConstantPool::TAGS{$info->tag};
				given( $tag_name ) {
				when('Integer') {
					$stack_frame->push_op( Java::VM::Variable->int_variable( $info->value ) );
				}
				when('Float') {
					$stack_frame->push_op( Java::VM::Variable->float_variable( $info->value ) );
				}
				when('Double') {
					$stack_frame->push_op( Java::VM::Variable->double_variable( $info->value ) );
				}
				when('Long') {
					$stack_frame->push_op( Java::VM::Variable->long_variable( $info->value ) );
				}
				when('String') {
					confess 'string constants not supported yet';
				}
				}
			}
			when('lstore') {
				$stack_frame->variables->[$instruction->[2]] = $stack_frame->pop_op;
			}
			when('lstore_0') {
				$stack_frame->variables->[0] = $stack_frame->pop_op;
			}
			when('lstore_1') {
				$stack_frame->variables->[1] = $stack_frame->pop_op;
			}
			when('lstore_2') {
				$stack_frame->variables->[2] = $stack_frame->pop_op;
			}
			when('lstore_3') {
				$stack_frame->variables->[3] = $stack_frame->pop_op;
			}
			default {
				warn "opcode $opcode ($mnemonic) not yet implemented";
			}
		}
		
		$instruction_index++;
	}
}

sub _get_last_stack_frame {
	my $self = shift;
	my @stack = @{$self->stack};
	$stack[-1];
}

sub BUILD {
	my $self = shift;
	
	my $initial_stack_frame = Java::VM::Stackframe->new(
		class	=> $self->class,
		method	=> $self->method );
		
	$self->push_stack_frame( $initial_stack_frame );
}

no Moose;

__PACKAGE__->meta->make_immutable;
