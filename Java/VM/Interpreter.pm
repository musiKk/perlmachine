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

has code_array => (
	is		=> 'rw',
	isa		=> 'ArrayRef'
);

my $code_map = Java::VM::Bytecode::Opcode::get_opcodes();

# when run is called, we have exactly one stack frame on our stack: the frame
# for the main method
sub run {
	my $self = shift;
	
	while(1) {
		my $stack_frame = $self->get_current_stack_frame;
		my $method = $stack_frame->method;
		my $class = $stack_frame->class;
		my $code_array = $self->code_array;
		my $instruction_index = $stack_frame->instruction_index;
		
		my $instruction = $code_array->[$instruction_index];
		my $opcode = $instruction->[1];
		
		my $mnemonic = $code_map->{$opcode}->mnemonic;
		given($mnemonic) {
			when('aload_0') {
				push @{$stack_frame->operand_stack}, $stack_frame->variables->[0];
			}
			when('dup') {
				my $var = $stack_frame->pop_op;
				$stack_frame->push_op( $var, $var );
			}
			when('ret') {
				$instruction_index = $instruction->[2];
				next;
			}
			when('return') {
				return if 1 == scalar @{$self->stack}; # the last stack frame - the main
				return if $method->name =~ /<c?init>/; # this is an initializer
				
				$self->pop_stack_frame;
				my $current_frame = $self->get_current_stack_frame;
				$current_frame->instruction_index( $current_frame->instruction_index + 1 );
				# some sort of code cache is needed
				$self->code_array( Java::VM::Bytecode::Decoder::decode( $current_frame->method->code_raw ) );
				next;
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
			when('invokestatic') {
				my $class_and_method = $self->_resolve_method( $class, $instruction->[2] );
				
				$self->push_stack_frame( Java::VM::Stackframe->new(
					class	=> $class_and_method->[0],
					method	=> $class_and_method->[1] ) );
				
				$self->code_array( Java::VM::Bytecode::Decoder::decode( $class_and_method->[1]->code_raw ) );
				next;
			}
			when('invokespecial') {
				my $class_and_method = $self->_resolve_method( $class, $instruction->[2] );
				my $object_var = $stack_frame->pop_op;
				
				my $new_stack_frame = Java::VM::Stackframe->new(
					class	=> $class_and_method->[0],
					method	=> $class_and_method->[1] );
				$new_stack_frame->variables->[0] = $object_var;
				
				$self->push_stack_frame( $new_stack_frame );
				$self->code_array( Java::VM::Bytecode::Decoder::decode( $class_and_method->[1]->code_raw ) );
				next;
			}
			when('new') {
				my $target_class = $self->_resolve_class( $class, $instruction->[2] );
				my $instance = $self->_create_instance( $target_class );
				$stack_frame->push_op( Java::VM::Variable::instance_variable( $instance ) );
			}
			when('pop') {
				$stack_frame->pop_op;
			}
			default {
				warn "opcode $opcode ($mnemonic) not yet implemented";
			}
		}
		
		$stack_frame->increment_instruction_index;
	}
}

sub _create_instance {
	my $self = shift;
	my $class = shift;
	
	# TODO execute <init>
	Java::VM::Instance->new( class => $class );
}

sub _resolve_class {
	my $self = shift;
	my $class = shift;
	my $classinfo_index = shift;
	
	my $target_class_name = $class->class->constant_pool->get_class_name( $classinfo_index );
	$self->_get_class( $class->classloader, $target_class_name );
}

# Resolves the method $methodref_index points to.
sub _resolve_method {
	my $self = shift;
	my $class = shift;
	my $methodref_index = shift;
	
	my $constant_pool = $class->class->constant_pool;
	my $methodref = $constant_pool->get_methodref( $methodref_index );
	
	my $class_name = $methodref->[0];
	my $method_name = $methodref->[1]->[0];
	my $method_descriptor = $methodref->[1]->[1];
	
	my $target_class = $self->_get_class( $class->classloader, $class_name );
	unless( $target_class ) {
		# ClassNotFoundException
		print "ClassNotFoundException: $class_name $method_name $method_descriptor\n";
		undef;
	}
	
	my $target_class_and_method = $self->_find_method( $target_class, $method_name, $method_descriptor );
	unless( $target_class_and_method ) {
		# NoSuchMethodException
		print "NoSuchMethodException: $class_name $method_name $method_descriptor\n";
		undef;
	}
	
	$target_class_and_method;
}

# Finds a method in $class or any super class.
sub _find_method {
	my $self = shift;
	my $class = shift;
	my $method_name = shift;
	my $method_descriptor = shift;
	
	my $method = $class->class->get_method( $method_name, $method_descriptor );
	if( $method ) {
		return [ $class, $method ];
	} else {
		my $super_class_name = $class->class->get_super_class_name;
		unless( $super_class_name ) {
			return undef;
		}
		
		my $super_class = $self->_get_class( $super_class_name );
		return $self->_find_method( $super_class, $method_name, $method_descriptor );
	}
}

sub _get_class {
	my $self = shift;
	my $classloader = shift;
	my $class_name = shift;
	
	my $class = $classloader->load_class( $class_name );
	# TODO initialization
	$class;
}

sub get_current_stack_frame {
	my $self = shift;
	$self->stack->[-1];
}

sub BUILD {
	my $self = shift;
	
	my $initial_stack_frame = Java::VM::Stackframe->new(
		class	=> $self->class,
		method	=> $self->method );
		
	$self->push_stack_frame( $initial_stack_frame );
	$self->code_array( Java::VM::Bytecode::Decoder::decode( $self->method->code_raw ) );
}

no Moose;

__PACKAGE__->meta->make_immutable;
