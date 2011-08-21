package Java::VM::NativeClassloader;

use File::Spec;
use Moose;

use Java::Class;
use Java::Class::Reader;
use Java::VM::Classloader;
use Java::VM::LoadedClass;

extends 'Java::VM::Classloader';

has 'classpath' => (
	is			=> 'rw',
	isa			=> 'Java::VM::Classpath',
	required	=> 1
);

sub load_class {
	my $self = shift;
	my $full_class_name = shift;
	
	my $class = $self->get_loaded_class( $full_class_name );
	return $class if $class; # this means the desired class and all super classes are already loaded
	
	my @name_parts = split m{/}, $full_class_name;
	my $class_name = pop @name_parts;
	
	my $relative_file_system_path = File::Spec->catfile( @name_parts, $class_name . '.class' );
	for my $classpath_entry (@{$self->classpath->entries}) {
		my $absolute_file_system_path = File::Spec->catfile( $classpath_entry, $relative_file_system_path );
		if(-e $absolute_file_system_path) {
			open my $fh, '<', $absolute_file_system_path or die $!;
			my $class = Java::Class->new( reader => Java::Class::Reader->new( handle => $fh ) );
			close $fh or warn $!;
			$class = Java::VM::LoadedClass->new( class => $class, classloader => $self );
			$self->register_class( $class );
			my $super_class_name = $class->class->get_super_class_name;
			if( $super_class_name ) {
				my $super_class = $self->load_class( $super_class_name );
				$class->super_class( $super_class );
			}
			return $class;
		}
	}
	return undef;
}

no Moose;

__PACKAGE__->meta->make_immutable;
