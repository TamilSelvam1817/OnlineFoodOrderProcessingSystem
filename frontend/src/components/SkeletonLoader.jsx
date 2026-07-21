import React from 'react';

export default function SkeletonLoader({ type = 'card', count = 4 }) {
  const CardSkeleton = () => (
    <div className="bg-white dark:bg-slate-800 rounded-3xl overflow-hidden border border-slate-100 dark:border-slate-700/60 shadow-sm">
      <div className="h-44 shimmer"></div>
      <div className="p-5 space-y-3">
        <div className="h-4 shimmer rounded-full w-3/4"></div>
        <div className="h-3 shimmer rounded-full w-full"></div>
        <div className="h-3 shimmer rounded-full w-1/2"></div>
        <div className="flex justify-between items-center pt-2">
          <div className="h-3 shimmer rounded-full w-1/3"></div>
          <div className="h-3 shimmer rounded-full w-1/4"></div>
        </div>
      </div>
    </div>
  );

  const ListSkeleton = () => (
    <div className="flex gap-4 p-4 bg-white dark:bg-slate-800 rounded-2xl border border-slate-100 dark:border-slate-700">
      <div className="w-20 h-20 shimmer rounded-2xl flex-shrink-0"></div>
      <div className="flex-1 space-y-2 py-1">
        <div className="h-4 shimmer rounded-full w-3/4"></div>
        <div className="h-3 shimmer rounded-full w-full"></div>
        <div className="h-3 shimmer rounded-full w-1/2"></div>
      </div>
    </div>
  );

  const items = Array.from({ length: count });

  if (type === 'list') {
    return (
      <div className="space-y-3">
        {items.map((_, i) => <ListSkeleton key={i} />)}
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
      {items.map((_, i) => <CardSkeleton key={i} />)}
    </div>
  );
}
