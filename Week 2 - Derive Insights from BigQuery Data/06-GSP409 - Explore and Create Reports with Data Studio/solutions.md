# ✅ Solutions — GSP409 (Click-Path Recipe)

> This lab is entirely point-and-click (no SQL), so the "solutions" are the
> exact click-path — in order, with the values to enter. Use it as a
> speed-run checklist.

## Task 1 — Launch Data Studio and create a blank report

1. Open **https://datastudio.google.com/** in a new tab — **signed in with the lab credentials**, not a personal account.
2. Click **Blank report** template.
3. First-run prompts:
   - Select **Country name**, enter any **Company name**, tick the terms checkbox → **Continue**.
   - Email preferences: **No** to all → **Continue**.
4. Click **Blank report** again → untitled report opens on the **Connect to data** tab.
5. **Google Connectors → BigQuery → Authorize**.
6. Configure the source:

   | Field | Value |
   |---|---|
   | Project | **Shared projects →** your `qwiklabs-...` Project ID |
   | Shared project name | `data-to-insights` |
   | Dataset | `ecommerce` |
   | Table | `sales_report` |

7. **Add** (bottom-right) → **Add to report**.
8. Practice with the field formatter:
   - **Add a chart → Table chart** → drop it on the canvas.
   - Drag **`ratio`** into **Dimension**.
   - Click the number icon on `ratio` → **Data type → Numeric → Percent**.
9. **Delete the practice table** (Task 2 builds the real one).
10. **Check my progress.** ✅

## Task 2 — Customize the report

### Title & page title

1. Click **"Untitled Report"** (top-left) → rename to `Ecommerce Product Operations Report`.
2. Toolbar **text icon (boxed A)** → click a blank area → type `Product Inventory Watchlist`.
3. Select the text → **Text Properties → font size 32px** → resize box to fit.

### The data table

4. **Insert → Table** → click to place; resize freely.
5. **Setup** tab:
   - **Dimension:** `productSKU` (drag in if missing).
   - **Metrics:** remove `Record count` (✕) → add `stockLevel`, `ratio`, `restockingLeadTime`.
   - **Sort:** switch from `productSKU` to **`ratio`**, **Descending**.
6. **Style** tab → tick **Wrap text** → drag column borders to tidy widths.

### Interactivity

7. **Setup** tab again:
   - Drag **`name`** into **Dimension**, *above* `productSKU`.
   - Drag **`total_ordered`** into **Metrics**, below `restockingLeadTime`.
8. Click **View** (upper-right) to preview the interactive, read-only report.

🏁 Done. Final table spec for quick verification:

| Slot | Fields (in order) |
|---|---|
| Dimensions | `name`, `productSKU` |
| Metrics | `stockLevel`, `ratio` (Percent), `restockingLeadTime`, `total_ordered` |
| Sort | `ratio` — Descending |
| Style | Wrap text on |
