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

dp = fill(-1, (4,n))
function countWays(skip, cur)
  if cur == n return nums[cur]-nums[cur-skip] <= 3 end
  if nums[cur]-nums[cur-skip] > 3 return 0 end
  if dp[skip, cur] != -1 return dp[skip, cur] end
  return dp[skip, cur] = countWays(skip+1, cur+1) + countWays(1, cur+1)
end

print("part1: ", d[1]*d[3], "\n")
print("part2: ", countWays(1, 2), "\n")