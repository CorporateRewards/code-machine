---
name: Bug report
about: Create a report to help us improve

---

# [Details]
```
[Problem]           Short Problem Description.
[Expected]          Short Description of Expected Behaviour.
[Environment]       http://myrrh.cr-dev.com/ (myrrh_staging) (Firefox 61.0.1 64-bit)
[Date Reported]     1970-01-01 00:00:00 +00:00
[Date Verified]     1970-01-01 00:00:00 +00:00
[Reported By]       Alexander Bednorz
[Verified By]       Ludovic Dachet
```

---

# [Description]
Full Description of issue.

```SQL
-- Error log or perhaps a query?
-- Content to aid investigation?
SELECT
            `mp`.*,
            `bs`.*
FROM        `my_problems`   AS `mp`
LEFT JOIN   `best_solution` AS `bs`
LIMIT       0, 1;
```

---

# [Steps to Replicate]
- ***Preliminary configuration***
    1. Steps to set up test.
    2. Provide details for configuration
- ***Steps***
    1. Steps to reproduce issue.
        - Example of results.
            ```JSON
                {
                    "test": "data",
                    "array":
                    [
                        { "x":0, "y":0, "z":0 }
                        { "x":0, "y":0, "z":0 }
                        { "x":0, "y":0, "z":0 }
                    ]
                }
            ```
    2. Provide steps and edge case criteria.
---

# [Evidence]
Some extra evidence to backup claims.

| Table of Things.              | Useful for formatting Data.                                       |
|:-----------------------------:|:------------------------------------------------------------------|
| Some context.                 | Some content.                                                     |

---

# [Acceptance Criteria]
- [ ] Expected behaviour and details of how this should be achieved.
- [ ] Some more criteria.
