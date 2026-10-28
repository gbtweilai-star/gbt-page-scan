# page_scan

**One capability bit from GBT V8, packaged standalone.** No. 270 of 341,
`system` domain (System).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **按绑定逐页并发扫**（主人 2026-10-12 定的架构「触手随每一页绑定好，扫的时候按绑定一页一页传回来」）：源 = state/page-bindings.json 的逐页（页→落点→正向_能力位，全在盘）；**按契约判色**——绿=跑通 / 黄=需参数或需授权（契约与门，不是故障）/ **红=契约也满足却仍失败**；页/落点/在册三项独立判；并发用满（实测引擎 ≥4096 根零失败）。op=scan/status

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-page-scan.git
cd gbt-page-scan
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_page_scan info                  # capability card
python -m gbt_page_scan spec --json           # machine-readable contract
python -m gbt_page_scan check --payload '{}'
python -m gbt_page_scan run   --payload '{}'
```

Real `info` output from this machine:

```text
page_scan  (system)  v1.0.0
----------------------------------------
**按绑定逐页并发扫**（主人 2026-10-12 定的架构「触手随每一页绑定好，扫的时候按绑定一页一页传回来」）：源 = state/page-bindings.json 的逐页（页→落点→正向_能力位，全在盘）；**按契约判色**——绿=跑通 / 黄=需参数或需授权（契约与门，不是故障）/ **红=契约也满足却仍失败**；页/落点/在册三项独立判；并发用满（实测引擎 ≥4096 根零失败）。op=scan/status

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : (multi-op, but the registry does not enumerate them)
```

Wire a real implementation:

```python
from gbt_page_scan import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表标注 `multi_op: true`，但没有枚举具体取值。**本包不替它编造取值清单——这种缺口应当在注册表源头补，而不是在文档里圆。

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.13s
```

## Provenance

| field | value |
|---|---|
| capability | `page_scan` |
| domain | `system` |
| handler | `page_scan` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [system/page_scan](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/system/page_scan.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
