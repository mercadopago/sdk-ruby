# Automatic pagination

Search endpoints return pages. For payments, customers, and preapprovals, `search_auto_paging_iter` exposes a lazy iterator that requests subsequent pages only as they are consumed:

```ruby
sdk.payment.search_auto_paging_iter(filters: { status: 'approved' }).each do |payment|
  process(payment)
end
```

Prefer the iterator when every item must be processed and the dataset is not known in advance. Keep manual `search` calls when the application needs page-level controls, a bounded UI response, or checkpointing by explicit offset.

Operational guidance:

- Apply the narrowest supported filters so fewer pages cross the network.
- Stop iteration as soon as the application has enough results.
- Make item processing idempotent; a restarted job can see an item again.
- Persist a business checkpoint when a long-running job must resume safely.
- Handle errors around the whole iteration because a later page can fail after earlier items were processed.

The iterator reduces pagination boilerplate; it does not load all results into memory or create a transactional snapshot across pages. Records can change while a long scan is running.
