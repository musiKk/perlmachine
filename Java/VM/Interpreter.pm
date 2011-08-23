package Java::VM::Interpreter;

use feature qw/ switch /;

use Moose;

use Java::VM;
use Java::VM::Bytecode::Decoder;
use Java::VM::LoadedClass;
use Java::VM::Stackframe;
use Java::VM::ArrayVariable;

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
		
		my $stack_depth = @{$self->stack} - 1;
		print ' |   ' x $stack_depth, $instruction_index,
			" executing opcode $mnemonic, function ",
			$method->name, ' (', $method->descriptor, 
			'), class: ', $class->class->get_name, "\n";
		
		given($mnemonic) {
			when('aconst_null') {
				$stack_frame->push_op( Java::VM::Variable::instance_variable( Java::VM->get_null() ) );
			}
			when(['aaload', 'iaload']) {
				my $index = $stack_frame->pop_op->value;
				my $array = $stack_frame->pop_op;
				$stack_frame->push_op( $array->value->[$index] );
			}
			when(['aastore', 'iastore']) {
				my $value = $stack_frame->pop_op;
				my $index = $stack_frame->pop_op->value;
				my $array = $stack_frame->pop_op;
				$array->value->[$index] = $value;
			}
			when('aload') {
				$stack_frame->push_op( $stack_frame->variables->[$instruction->[2]] );
			}
			when('aload_0') {
				$stack_frame->push_op( $stack_frame->variables->[0] );
			}
			when('aload_1') {
				$stack_frame->push_op( $stack_frame->variables->[1] );
			}
			when('aload_2') {
				$stack_frame->push_op( $stack_frame->variables->[2] );
			}
			when('aload_3') {
				$stack_frame->push_op( $stack_frame->variables->[3] );
			}
			when('astore') {
				$stack_frame->variables->[$instruction->[2]] = $stack_frame->pop_op;
			}
			when('astore_0') {
				$stack_frame->variables->[0] = $stack_frame->pop_op;
			}
			when('astore_1') {
				$stack_frame->variables->[1] = $stack_frame->pop_op;
			}
			when('astore_2') {
				$stack_frame->variables->[2] = $stack_frame->pop_op;
			}
			when('astore_3') {
				$stack_frame->variables->[3] = $stack_frame->pop_op;
			}
			when('bipush') {
				$stack_frame->push_op( Java::VM::Variable::byte_variable( $instruction->[2] ) );
			}
			when('dup') {
				my $var = $stack_frame->pop_op;
				$stack_frame->push_op( $var, $var );
			}
			when('goto') {
				$self->_set_instruction_index( $instruction->[2] );
			}
			when('ret') {
				$instruction_index = $instruction->[2];
				next;
			}
			when('return') {
				return if 1 == scalar @{$self->stack}; # the last stack frame - the main
				
				my $previous_stack_frame = $self->pop_stack_frame;
				my $current_frame = $self->get_current_stack_frame;
				# some sort of code cache is needed
				$self->code_array( Java::VM::Bytecode::Decoder::decode( $current_frame->method->code_raw ) );
				
				return if $previous_stack_frame->return_control;
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
				$stack_frame->push_op( Java::VM::Variable::int_variable( -1 ) );
			}
			when('iconst_0') {
				$stack_frame->push_op( Java::VM::Variable::int_variable( 0 ) );
			}
			when('iconst_1') {
				$stack_frame->push_op( Java::VM::Variable::int_variable( 1 ) );
			}
			when('iconst_2') {
				$stack_frame->push_op( Java::VM::Variable::int_variable( 2 ) );
			}
			when('iconst_3') {
				$stack_frame->push_op( Java::VM::Variable::int_variable( 3 ) );
			}
			when('iconst_4') {
				$stack_frame->push_op( Java::VM::Variable::int_variable( 4 ) );
			}
			when('iconst_5') {
				$stack_frame->push_op( Java::VM::Variable::int_variable( 5 ) );
			}
			when('iaload') {
				my $index = $stack_frame->pop_op->value;
				my $array = $stack_frame->pop_op;
				$stack_frame->push_op( Java::VM::Variable::int_variable( $array->value->[$index] ) );
			}
			when('iload') {
				$stack_frame->push_op( $stack_frame->variables->[$instruction->[2]] );
			}
			when('iload_0') {
				$stack_frame->push_op( $stack_frame->variables->[0] );
			}
			when('iload_1') {
				$stack_frame->push_op( $stack_frame->variables->[1] );
			}
			when('iload_2') {
				$stack_frame->push_op( $stack_frame->variables->[2] );
			}
			when('iload_3') {
				$stack_frame->push_op( $stack_frame->variables->[3] );
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
			when('iadd') {
				my $value2 = $stack_frame->pop_op->value;
				my $value1 = $stack_frame->pop_op->value;
				# TODO account for overflow
				$stack_frame->push_op( Java::VM::Variable::int_variable( $value1 + $value2 ) );
			}
			when('isub') {
				my $value2 = $stack_frame->pop_op->value;
				my $value1 = $stack_frame->pop_op->value;
				# TODO account for overflow
				$stack_frame->push_op( Java::VM::Variable::int_variable( $value1 - $value2 ) );
			}
			when(['ireturn', 'areturn']) {
				my $return_variable = $stack_frame->pop_op;
				$self->pop_stack_frame;
				
				my $current_frame = $self->get_current_stack_frame;
				$current_frame->increment_instruction_index;
				$current_frame->push_op( $return_variable );
				$self->code_array( Java::VM::Bytecode::Decoder::decode( $current_frame->method->code_raw ) );
			}
			when(['ldc','ldc_w','ldc2_w']) {
				my $constant_pool = $stack_frame->class->class->constant_pool;
				my $info = $constant_pool->get_info( $instruction->[2] );
				print 'constant at index ', $instruction->[2], "\n";
				my $tag_name = $Java::Class::ConstantPool::TAGS{$info->tag};
				given( $tag_name ) {
				when('Integer') {
					$stack_frame->push_op( Java::VM::Variable::int_variable( $info->value ) );
				}
				when('Float') {
					$stack_frame->push_op( Java::VM::Variable::float_variable( $info->value ) );
				}
				when('Double') {
					$stack_frame->push_op( Java::VM::Variable::double_variable( $info->value ) );
				}
				when('Long') {
					$stack_frame->push_op( Java::VM::Variable::long_variable( $info->value ) );
				}
				when('String') {
					my $string_literal = $constant_pool->get_string( $instruction->[2] );
					print 'requesting string constant for ', $string_literal, "\n";
					my $string_instance = Java::VM::get_string_instance( $string_literal );
					if( $string_instance ) {
						$stack_frame->push_op( $string_instance );
					} else {
						my $string_instance = $self->_create_instance( $self->_get_class( $stack_frame->class->classloader, 'java/lang/String' ) );
						print "created new string instance $string_instance\n";
						
						my @chars = split //, $string_literal;
						print 'characters: ', join(', ', @chars), "\n";
						my $char_array = Java::VM::Variable::array_variable( scalar @chars, 5 );
						for( my $i=0; $i<scalar @chars; $i++ ) {
							$char_array->value->[$i] = $chars[$i];
						}
						
						my $string_constructor = $string_instance->class->class->get_method( '<init>', '([C)V' );
						confess 'couldn\'t find string constructor' unless $string_constructor;
						
						my $new_stack_frame = Java::VM::Stackframe->new(
							method	=> $string_constructor,
							class	=> $string_instance->class );
						$new_stack_frame->variables->[0] = Java::VM::Variable::instance_variable( $string_instance );
						$new_stack_frame->variables->[1] = $char_array;
						$self->push_stack_frame( $new_stack_frame );
						$self->code_array( Java::VM::Bytecode::Decoder::decode( $string_constructor->code_raw ) );
						continue;
					}
				}
				}
			}
			when('lload') {
				$stack_frame->push_op( $stack_frame->variables->[$instruction->[2]] );
			}
			when('lload_0') {
				$stack_frame->push_op( $stack_frame->variables->[0] );
			}
			when('lload_1') {
				$stack_frame->push_op( $stack_frame->variables->[1] );
			}
			when('lload_2') {
				$stack_frame->push_op( $stack_frame->variables->[2] );
			}
			when('lload_3') {
				$stack_frame->push_op( $stack_frame->variables->[3] );
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
			when('sipush') {
				$stack_frame->push_op( Java::VM::Variable::short_variable( $instruction->[2] ) );
			}
			when(/if(_icmp)?(eq|ne|lt|le|gt|ge)/) {
				my $mode = $2;
				my $val2;
				if( $1 ) {
					$val2 = $stack_frame->pop_op->value;
				} else {
					$val2 = 0;
				}
				my $val1 = $stack_frame->pop_op->value;
				
				my $result;
				given($mode) {
					when('eq') { $result = $val1 == $val2 }
					when('ne') { $result = $val1 != $val2 }
					when('lt') { $result = $val1  < $val2 }
					when('le') { $result = $val1 <= $val2 }
					when('gt') { $result = $val1  > $val2 }
					when('ge') { $result = $val1 >= $val2 }
				}
				if( $result ) {
					$self->_set_instruction_index( $instruction->[2] );
					next;
				}
			}
			when(/if(non)?null/) {
				my $value = $stack_frame->pop_op->value;
				if( defined $1 != $value->null ) {
					$self->_set_instruction_index( $instruction->[2] );
					next;
				}
			}
			when('invokestatic') {
				my $class_and_method = $self->_resolve_method( $class, $instruction->[2] );
				
				my $class = $class_and_method->[0];
				my $method = $class_and_method->[1];
				
				if( $method->is_native && $class->class->get_name eq 'java/lang/VMSystem'
					&& $method->name eq 'arraycopy' ) {
					
					my $length = $stack_frame->pop_op->value;
					my $dest_pos = $stack_frame->pop_op->value;
					my $dest = $stack_frame->pop_op;
					my $src_pos = $stack_frame->pop_op->value;
					my $src = $stack_frame->pop_op;
					
					printf "System.arraycopy(%s, %d, %s, %d, %d)\n",
						$src, $src_pos, $dest, $dest_pos, $length;
					
					my $cur_src_pos = $src_pos;
					my $cur_dest_pos = $dest_pos;
					while( 1 ) {
						last if $cur_src_pos > ( $src_pos + $length );
						$dest->value->[$cur_dest_pos] = $src->value->[$cur_src_pos++];
					}
					$stack_frame->increment_instruction_index;
					next;
				}
				
				my $new_stack_frame = Java::VM::Stackframe->new(
					class	=> $class_and_method->[0],
					method	=> $class_and_method->[1] );
				
				$new_stack_frame->fill_variables(
					$class_and_method->[1]->descriptor,
					$stack_frame,
					1 );
				
				$self->push_stack_frame( $new_stack_frame );
				
				$self->code_array( Java::VM::Bytecode::Decoder::decode( $class_and_method->[1]->code_raw ) );
			}
			# some day I'm gonna read up what the difference between those is...
			when(['invokespecial','invokeinterface','invokevirtual']) {
				my $class_and_method = $self->_resolve_method( $class, $instruction->[2] );
				
				my $new_stack_frame = Java::VM::Stackframe->new(
					class	=> $class_and_method->[0],
					method	=> $class_and_method->[1] );
				
				$new_stack_frame->fill_variables(
					$class_and_method->[1]->descriptor,
					$stack_frame,
					0 );
				
				$self->push_stack_frame( $new_stack_frame );
				$self->code_array( Java::VM::Bytecode::Decoder::decode( $class_and_method->[1]->code_raw ) );
				next;
			}
			when('new') {
				my $target_class = $self->_resolve_class( $class, $instruction->[2] );
				my $instance = $self->_create_instance( $target_class );
				$stack_frame->push_op( Java::VM::Variable::instance_variable( $instance ) );
			}
			when('newarray') {
				my $length = $stack_frame->pop_op->value;
				my $array = Java::VM::Variable::array_variable( $length, $instruction->[2] );
				$stack_frame->push_op( $array );
			}
			when('anewarray') {
				my $length = $stack_frame->pop_op->value;
				my $class_name = $stack_frame->class->class->constant_pool->get_class_name( $instruction->[2] );
				if( $class_name !~ /^\[/ ) {
					$class_name = 'L' . $class_name . ';';
				}
				my $array = Java::VM::Variable::array_variable( $length, $class_name );
				$stack_frame->push_op( $array );
			}
			when('arraylength') {
				my $array = $stack_frame->pop_op;
				$stack_frame->push_op( Java::VM::Variable::int_variable( $array->length ) );
			}
			when('pop') {
				$stack_frame->pop_op;
			}
			when('putfield') {
				my $value = $stack_frame->pop_op;
				my $instance = $stack_frame->pop_op->value;
				
				my $fieldref = $class->class->constant_pool->get_fieldref( $instruction->[2] );
				$instance->get_field( $fieldref )->value( $value );
			}
			when('getfield') {
				my $instance = $stack_frame->pop_op->value;
				my $fieldref = $class->class->constant_pool->get_fieldref( $instruction->[2] );
				$stack_frame->push_op( $instance->get_field( $fieldref )->value );
			}
			when('putstatic') {
				my $field = $self->_get_static_field( $instruction->[2] );
				$field->value( $stack_frame->pop_op );
			}
			when('getstatic') {
				my $field = $self->_get_static_field( $instruction->[2] );
				$stack_frame->push_op( $field->value );
			}
			default {
				warn "opcode $opcode ($mnemonic) not yet implemented (in class ", $class->class->get_name, ")";
			}
		}
		
		$stack_frame->increment_instruction_index;
	}
}

sub _set_instruction_index {
	my $self = shift;
	my $offset = shift;
	my $stack_frame = $self->get_current_stack_frame;
	my $current_instruction_index = $stack_frame->instruction_index;

	my $target_byte = $self->code_array->[$current_instruction_index]->[0] + $offset;
	my $target_instruction_index = $current_instruction_index;
	my $current_byte;
	while( ( $current_byte = $self->code_array->[$target_instruction_index]->[0] ) != $target_byte ) {
		if( $current_byte > $target_byte ) {
			$target_instruction_index--;
		} else {
			$target_instruction_index++;
		}
	}
	$stack_frame->instruction_index( $target_instruction_index );
}

sub _get_static_field {
	my $self = shift;
	my $fieldref_index = shift;
	
	my $stack_frame = $self->get_current_stack_frame;
	
	my $class = $stack_frame->class;
	
	my $fieldref = $class->class->constant_pool->get_fieldref( $fieldref_index );
	
	my $target_class = $self->_get_class( $class->classloader, $fieldref->[0] );
	$target_class->get_field( $fieldref );
}

sub _create_instance {
	my $self = shift;
	my $class = shift;
	
	my $instance = Java::VM::Instance->new( class => $class );
	$instance;
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
	
	if( $target_class_and_method->[1]->is_native ) {
		# TODO implement
		print "UnsatisfiedLinkError: $class_name $method_name $method_descriptor\n";
#		undef;
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
	
	my $method = $class->class->get_method( '<clinit>', '()V' );
	if( $method && $class->requires_initialization ) {
		# if this is set at the end of initialization, we easily get in an endless recursion
		$class->requires_initialization( 0 );
		
		$self->push_stack_frame( Java::VM::Stackframe->new(
			class			=> $class,
			method			=> $method,
			return_control	=> 1 ) );
		$self->code_array( Java::VM::Bytecode::Decoder::decode( $method->code_raw ) );
		$self->run;
	}
	
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
