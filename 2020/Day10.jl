text = readlines("input.txt")
nums = [parse(Int, x) for x in text]
append!(nums, 0)
nums = sort(nums)
append!(nums, last(nums)+3)

n = size(nums, 1);

d = [0, 0, 0]
for i = 2:n
  d[nums[i]-nums[i-1]] += 1
end

dp = fill(-1, (n,n))
function countWays(prev, cur)
  if cur == n return nums[cur]-nums[prev] <= 3 end
  if nums[cur]-nums[prev] > 3 return 0 end
  if dp[prev, cur] != -1 return dp[prev, cur] end
  return dp[prev, cur] = countWays(prev, cur+1) + countWays(cur, cur+1)
end

print("part1: ", d[1]*d[3], "\n")
print("part2: ", countWays(1, 2), "\n")