---
layout: post
title: Answering How Many with Software
categories:
- writing
tags: []
status: publish
type: post
published: true
---

_How many?_ is a typical question that comes up when programming. I use a variety of software
for projects and there are subtly different ways to answer that question depending on the context.

Here is an alphabetical list of ways I've recently answered that question.
A more detailed comparison of programming languages can be found on [Wikipedia](https://en.wikipedia.org/wiki/Comparison_of_programming_languages){:target="\_blank"}.

### Command Line
{% highlight shell %}
# How many rows are in this file?
wc -l < file
{% endhighlight %}

### Golang
{% highlight go %}
// How many elements are in this array?
len(array)
{% endhighlight %}

### JavaScript
{% highlight javascript %}
// How many elements are in this array?
array.length

// How many elements in this array are greater than 5?
d3.count(array, (d) => d > 5)

// How many rows are in this Apache Arrow table?
table.numRows
{% endhighlight %}

### Liquid Tags in Jekyll
{% highlight html %}
<!-- How many elements are in this array? -->
array | size
{% endhighlight %}

### Python
{% highlight python %}
# How many elements are in this list?
len(list)

# How many elements are in this pandas dataframe?
df.size # including missing values
df.count() # excluding missing values

# How many elements are in this numpy array?
ndarray.size
{% endhighlight %}

### Ruby
{% highlight ruby %}
# How many elements are in this array?
array.length
array.count
array.size

# How many rows are in this Active Record table?
table.count
{% endhighlight %}

### SQL
{% highlight sql %}
-- How many elements are in this PostgreSQL array?
array_length(array, 1)

-- How many elements are in this DuckDB list?
len(list)

-- How many rows are in this table?
select count(*) from table
{% endhighlight %}

### Terraform
{% highlight ruby %}
# How many elements are in this list?
length(list)
{% endhighlight %}
