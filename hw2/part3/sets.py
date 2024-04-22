def main():
    #{Number of production rule: ({first sets}, {Follow up sets})
    sets = {
        0: ({"INT", ""}, {""}),
        1: ({"INT", ""}, {""}),
        2: ({"INT"}, {""}),
        3: ({""}, {""}),
        4: ({"INT"}, {""}),
        5: ({"INT"}, {""})
    }

    print("Rule Number | FIRST Sets    | FOLLOW Sets")
    print("-" * 50)

    for rule_number, (first_set, follow_set) in sets.items():
        first_formatted = ', '.join(sorted(s for s in first_set if s))
        follow_formatted = ', '.join(sorted(s for s in follow_set if s))
        print(f"{rule_number:12} | {first_formatted:15} | {follow_formatted}")

if __name__ == "__main__":
    main()

