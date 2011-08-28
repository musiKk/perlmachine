package Java::VM;

use Moose;

use Java::VM::Classpath;
use Java::VM::Instance;
use Java::VM::Interpreter;
use Java::VM::LoadedClass;
use Java::VM::NativeClassloader;

has class_name => (
	is			=> 'rw',
	isa			=> 'Str',
	required	=> 1
);

has classpath => (
	is			=> 'rw',
	isa			=> 'Java::VM::Classpath',
	required	=> 1,
	default		=> sub { Java::VM::Classpath->new( entries => [ '.' ] ) }
);

# this is the only instance of a null in the whole VM
my $NULL_INSTANCE = Java::VM::Instance->new( null => 1 );

my %INTERNED_STRINGS = ();

sub start {
	my $self = shift;
	
	# the user should supply dot-notation, the jvm uses /-notation
	# e.g. java.lang.String vs. java/lang/String
	my $class_name = $self->class_name;
	$class_name =~ s/\./\//g;
	$self->class_name( $class_name );
	
	# TODO argument parsing for classpath
	my $class_loader = Java::VM::NativeClassloader->new( classpath => $self->classpath );
	my $main_class = $class_loader->load_class( $self->class_name );
	unless( $main_class ) {
		die 'main class ', $class_name, ' not found';
	}
	
	my $main_method = $main_class->class->get_method( [ 'main', '([Ljava/lang/String;)V' ] );
	unless( $main_method ) {
		die 'main method not found in class ', $main_class;
	}
	
	my $interpreter = Java::VM::Interpreter->new(
		class	=> $main_class,
		method	=> $main_method );
	$interpreter->run;
}

sub get_null {
	$NULL_INSTANCE;
}

sub get_string_instance {
	my $string = shift;
	$INTERNED_STRINGS{$string};
}

sub intern_string {
	my $string = shift;
	my $instance = shift;
	$INTERNED_STRINGS{$string} = $instance;
}

no Moose;

__PACKAGE__->meta->make_immutable;
