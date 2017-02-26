# coding=utf-8
class Rho(object):
    def __init__(self, x):
        self.x = x

class RecursiveT(object):
    def __init__(self):
        self.recursivity = 1
        self.rules = None
        self.unused = None

    def set_rules(self, rules):
        self.rules = rules
        self.unused = set(rules)

    def get_usage(self, last):
        def criterion(rule):
            return (last and rule.recursivity >= 2 and not rule.is_used(),
                    last and rule.recursivity >= 1 and not rule.is_used(),
                    rule in self.unused,
                    not rule.is_used(),
                    -rule.recursivity)
        rule = max(self.rules, key=criterion)
        self.unused -= {rule}
        return Rho(rule.get_usage(last))

    def is_used(self):
        return len(self.unused) == 0

class ListT(object):
    def __init__(self, *subs):
        self.subs = subs
        self.recursivity = sum(sub.recursivity for sub in subs)

    def set_rules(self, rules):
        for sub in self.subs:
            sub.set_rules(rules)

    def get_usage(self, last):
        usages = [None] * len(self.subs)
        rec_count = 0
        do_first = [i for i in range(len(self.subs)) if not self.subs[i].is_used()]
        do_second = [i for i in range(len(self.subs)) if i not in do_first]
        for i in do_first + do_second:
            rec_count += self.subs[i].recursivity
            usages[i] = self.subs[i].get_usage(last and rec_count == self.recursivity)
        return usages

    def is_used(self):
        return all(sub.is_used() for sub in self.subs)

class LiteralT(object):
    def __init__(self, *examples):
        self.examples = examples
        self.recursivity = 0
        self.index = 0

    def set_rules(self, rules):
        pass

    def get_usage(self, _):
        usage = self.examples[self.index]
        self.index = (self.index + 1) % len(self.examples)
        return usage

    def is_used(self):
        return True

class VariadicT(object):
    def __init__(self, rep):
        self.rep = rep
        self.recursivity = rep.recursivity
        self.repetitions = 4

    def set_rules(self, rules):
        self.rep.set_rules(rules)

    def get_usage(self, last):
        reps = max(self.repetitions, (last or not self.rep.is_used()))
        self.repetitions = max(0, self.repetitions - 1)
        usages = tuple(self.rep.get_usage(last and i == reps - 1) for i in range(reps))
        return usages

    def is_used(self):
        return self.rep.is_used()

class IdentifierT(LiteralT):
    def __init__(self, examples):
        examples += [chr(i) for i in range(ord('a'), ord('z') + 1)]
        super(IdentifierT, self).__init__(*examples)

def to_sexp(output):
    if isinstance(output, list):
        return "{" + ' '.join(filter(lambda x: len(x) > 0, map(to_sexp, output))) + "}"
    if isinstance(output, tuple):
        return ' '.join(map(to_sexp, output))
    if isinstance(output, Rho):
        return '(ρ ' + to_sexp(output.x) + ')'
    return str(output)

def main():

    rules2 = [
        ListT(LiteralT('+', '*', '-'), RecursiveT(), RecursiveT()),
        ListT(LiteralT('/'), RecursiveT(), RecursiveT()),
        ListT(LiteralT('ifleq0'), RecursiveT(), RecursiveT(), RecursiveT()),
        ListT(IdentifierT([]), VariadicT(RecursiveT())),
        IdentifierT([]),
        LiteralT(1, -1, '2.2', '-22/7'),
        LiteralT(0),
    ]

    rules3 = [
        ListT(LiteralT('if'), RecursiveT(), RecursiveT(), RecursiveT()),
        ListT(RecursiveT(), VariadicT(RecursiveT())),
        ListT(LiteralT('var'), VariadicT(ListT(IdentifierT([]), LiteralT('='), RecursiveT())), RecursiveT()),
        ListT(LiteralT('lam'), ListT(VariadicT(IdentifierT([]))), RecursiveT()),
        ListT(LiteralT('+', '-', '*', 'eq?', '<='), RecursiveT(), RecursiveT()),
        ListT(LiteralT('/'), RecursiveT(), RecursiveT()),
        IdentifierT([]),
        LiteralT(1, -1, '2.2', '-22/7'),
        LiteralT(0),
        LiteralT('true', 'false')
    ]

    phym4ids = list("true false null + - * / eq? <= array new-array aref aset! begin substring".split())

    rules4 = [
        ListT(LiteralT('if'), RecursiveT(), RecursiveT(), RecursiveT()),
        ListT(RecursiveT(), VariadicT(RecursiveT())),
        ListT(LiteralT('var'), VariadicT(ListT(IdentifierT(phym4ids), LiteralT('='), RecursiveT())), RecursiveT()),
        ListT(LiteralT('lam'), ListT(VariadicT(IdentifierT(phym4ids))), RecursiveT()),
        IdentifierT(phym4ids),
        LiteralT('"Hello"', '"World"'),
        LiteralT(1, -1, '2.2', '-22/7'),
        LiteralT(0),
    ]

    phym5ids = list("true false + - * / eq? <= substring".split())

    rules5 = [
        ListT(LiteralT('if'), RecursiveT(), RecursiveT(), RecursiveT()),
        ListT(RecursiveT(), VariadicT(RecursiveT())),
        ListT(LiteralT('var'), VariadicT(ListT(IdentifierT(phym5ids), LiteralT('='), RecursiveT())), RecursiveT()),
        ListT(LiteralT('lam'), ListT(VariadicT(IdentifierT(phym5ids))), RecursiveT()),
        ListT(LiteralT('new'), IdentifierT(phym5ids), VariadicT(RecursiveT())),
        ListT(LiteralT('send'), RecursiveT(), RecursiveT(), VariadicT(RecursiveT())),
        ListT(LiteralT('rec'), ListT(IdentifierT(phym5ids), LiteralT('='), RecursiveT()), RecursiveT()),
        IdentifierT(['this'] + phym5ids),
        LiteralT('"Hello"', '"World"'),
        LiteralT(1, -1, '2.2', '-22/7'),
        LiteralT(0)
    ]

    rules = rules5

    for rule in rules:
        rule.set_rules(rules)

    print "(ρ " + to_sexp(rules[0].get_usage(True)) + ")"


if __name__ == '__main__':
    main()
