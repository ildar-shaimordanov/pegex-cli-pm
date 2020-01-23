package Pegex::Calc;

use Pegex::Base;
use Pegex::Parser;

sub load {
    my ($self, $input) = @_;
    Pegex::Parser->new(
        grammar => Pegex::Calc::Grammar->new,
        receiver => Pegex::Calc::Data->new,
        # debug => 1,
    )->parse($input);
}

# =========================================================================

package Pegex::Calc::Grammar;

#use Pegex::Base;
use base 'Pegex::Grammar';

use constant text => <<'...';
calc:
	expr ws

expr:
	add-sub

add-sub:
	mul-div+ % /- ( [ '+-' ])/

mul-div:
	power+ % /- ([ '*/' ])/

power:
	token+ % /- '^' /

token:
	/- '(' -/ expr /- ')'/ | number

number:
	/- ( '-'? DIGIT+ )/

ws:
	/ (: WS | EOS ) /
...

# =========================================================================

package Pegex::Calc::Data;

use base 'Pegex::Tree';

sub gotrule {
	my ($self, $list) = @_;
	return $list unless ref $list;

	if ($self->rule eq 'power') {
		# Right associative:
		while (@$list > 1) {
			my ($a, $b) = splice(@$list, -2, 2);
			push @$list, $a ** $b;
		}
	} else {
		# Left associative:
		while (@$list > 1) {
			my ($a, $op, $b) = splice(@$list, 0, 3);
			return $a unless $op;
			unshift @$list,
				($op eq '+') ? ($a + $b) :
				($op eq '-') ? ($a - $b) :
				($op eq '*') ? ($a * $b) :
				($op eq '/') ? ($a / $b) :
				die;
		}
	}
	return pop @$list;
}

1;

# =========================================================================

# EOF
