# daiji256/delete-orphan-branch

During a GitHub Actions workflow, this action deletes remote orphan branches that match user-specified criteria.

Companion actions are available: upload at [daiji256/upload-to-orphan-branch](https://github.com/Daiji256/upload-to-orphan-branch) and download at [daiji256/download-from-orphan-branch](https://github.com/Daiji256/download-from-orphan-branch). End-to-end usage examples are provided in [orphan-branch-upload-download-delete-examples](https://github.com/Daiji256/orphan-branch-upload-download-delete-examples).

## Why delete orphan branches

If you keep saving workflow outputs in new orphan branches, the branch list grows, clutters the repository, and slowly increases its size. Deleting old branches prevents that.

## How it works

1. Fetch remote branches.
2. Skip HEAD.
3. For each branch matching `branch-regex`, ensure it has one commit, expected committer/message, and is old enough.
4. Delete the branches that pass all checks.

## Inputs

| Input                    | Default                                               | Description                                                                                          |
| ------------------------ | ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| branch-regex             | -                                                     | Regex to match branch names eligible for deletion.                                                   |
| expected-committer-name  | github-actions[bot]                                   | Delete only branches whose committer name exactly matches this.                                      |
| expected-committer-email | 41898282+github-actions[bot]@users.noreply.github.com | Delete only branches whose committer email exactly matches this.                                     |
| expected-commit-message  | -                                                     | Delete only branches whose commit message exactly matches this. Omit to ignore message filtering.    |
| older-than-seconds       | 0                                                     | Delete branches only if they are older than this many seconds. Set 0 to delete all matched branches. |

## Notes

- Requires workflow permission: `contents: write`.
- Choose a precise `branch-regex` to avoid deleting unintended branches.

## Example

```yaml
jobs:
  delete:
    runs-on: ubuntu-latest
    permissions:
      contents: write

    steps:
      - uses: actions/checkout@v5
        with:
          fetch-depth: 0

      - uses: daiji256/delete-orphan-branch@v0.1.0
        with:
          branch-regex: orphan-output-*
          older-than-seconds: 604800 # 7 days
```

## License

[MIT](LICENSE) © [Daiji256](https://github.com/Daiji256)
