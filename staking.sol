// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}


contract SpunkyStaking is Ownable, ReentrancyGuard {
    string public name;

    // Define the staking plans
    enum StakingPlan {
        ThirtyDays,
        NinetyDays,
        OneEightyDays,
        ThreeSixtyDays,
        Flexible
    }

    // Define the returns for each plan
    mapping(StakingPlan => uint256) private _stakingPlanReturns;

    // Define the duration for each plan
    mapping(StakingPlan => uint256) private _stakingPlanDurations;

    // Total staked amount
    uint256 private _totalStakedAmount = 0;

    address public spunkyTokenAddress;

    // Staking details
    struct UserStake {
        uint256 index;
        address owner;
        uint256 amount;
        uint256 startTime;
        StakingPlan plan;
        uint256 reward;
        uint256 accruedReward;
        bool isActive;
    }

    UserStake[] private _stakingDetails;
    mapping(address => mapping(StakingPlan => UserStake)) private _userStakes;

    // Events
    event Stake(address indexed user, uint256 amount, StakingPlan plan);
    event UpdateStake(address indexed user, uint256 newAmount, StakingPlan plan);
    event ClaimRewards(address indexed user, uint256 reward);
    event Unstake(address indexed user, uint256 amount, StakingPlan plan);

    constructor() {
        name = "SpunkySDXStaking";
          // Define the returns for each staking plan
        _stakingPlanReturns[StakingPlan.ThirtyDays] = 5;
        _stakingPlanReturns[StakingPlan.NinetyDays] = 10;
        _stakingPlanReturns[StakingPlan.OneEightyDays] = 30;
        _stakingPlanReturns[StakingPlan.ThreeSixtyDays] = 50;
        _stakingPlanReturns[StakingPlan.Flexible] = 1;

        // Initialize the durations for each staking plan
        _stakingPlanDurations[StakingPlan.ThirtyDays] = 30;
        _stakingPlanDurations[StakingPlan.NinetyDays] = 90;
        _stakingPlanDurations[StakingPlan.OneEightyDays] = 180;
        _stakingPlanDurations[StakingPlan.ThreeSixtyDays] = 360;
        _stakingPlanDurations[StakingPlan.Flexible] = 2;
    }

// Your staking functions here
function stake(
    uint256 amount,
    StakingPlan plan
) external nonReentrant {
    require(amount > 0, "The staking amount must be greater than zero.");
    UserStake storage userStake = _userStakes[msg.sender][plan];
    require(
        userStake.amount == 0,
        "User already staking; add to your stake or unstake."
    );
    require(!userStake.isActive, "Plan is already active");

    uint256 reward = calculateStakingReward(amount, plan);

    require(IERC20(spunkyTokenAddress).balanceOf(address(this)) >= reward, "Staking rewards exhausted");

    // Transfer tokens from the user to this contract
    IERC20(spunkyTokenAddress).transferFrom(msg.sender, address(this), amount);

    _totalStakedAmount += amount;

    // If you want to decrement the staking allocation balance, you should do it in your logic
    // but you can't directly change the token balance like this.
    // You might want to manage a separate state variable for that.

    // Update stake and push into an array
    userStake.owner = msg.sender;
    userStake.amount = amount;
    userStake.startTime = block.timestamp;
    userStake.plan = plan;
    userStake.reward = reward;
    userStake.accruedReward = 0;
    userStake.index = _stakingDetails.length;
    userStake.isActive = true;

    _stakingDetails.push(userStake);

    emit Stake(msg.sender, amount, plan);
}


    
   function addToStake(
    uint256 additionalAmount,
    StakingPlan plan
) external nonReentrant {
    require(additionalAmount > 0, "Invalid additional staking amount");
    UserStake storage userStake = _userStakes[msg.sender][plan];
    require(userStake.amount > 0, "No existing stake found");

    // Calculate the new accrued reward
    uint256 newAccruedReward = calculateAccruedReward(
        userStake.amount,
        plan
    );

    require(
        IERC20(spunkyTokenAddress).balanceOf(address(this)) >= newAccruedReward,
        "Staking rewards exhausted"
    );

    // If you want to decrement the staking allocation balance, you should do it in your logic
    // but you can't directly change the token balance like this.
    // You might want to manage a separate state variable for that.

    // Update the staking state
    userStake.accruedReward += newAccruedReward;
    userStake.amount += additionalAmount;
    userStake.startTime = block.timestamp;
    _totalStakedAmount += additionalAmount;

    // Transfer the additional staked amount from the user to the contract
    IERC20(spunkyTokenAddress).transferFrom(msg.sender, address(this), additionalAmount);

    // Update staking details in the array
    uint256 detailsIndex = userStake.index;
    _stakingDetails[detailsIndex].accruedReward = newAccruedReward;
    _stakingDetails[detailsIndex].amount += additionalAmount;
    _stakingDetails[detailsIndex].startTime = block.timestamp;

    // Emit update
    emit UpdateStake(msg.sender, userStake.amount, plan);
}


    function claimReward(StakingPlan plan) internal view returns (uint256) {
    // Load the user's stake details into memory
    UserStake memory userStake = _userStakes[msg.sender][plan];

    // Ensure the user has a valid stake
    require(userStake.amount > 0, "No staking balance available");

    // Calculate the initial reward (plan reward + accrued reward)
    uint256 reward = userStake.reward + userStake.accruedReward;

    // Handle flexible plans differently
    if (plan == StakingPlan.Flexible) {
        uint256 addedReward = calculateAccruedReward(
            userStake.amount,
            plan
        );

        // Ensure there's enough in the reward pool
        uint256 currentBalance = IERC20(spunkyTokenAddress).balanceOf(address(this));
        if (currentBalance >= addedReward) {
            reward += addedReward;
        } else {
            reward += currentBalance;
        }
    }

    return reward;
}



  function userClaimReward(StakingPlan plan) external nonReentrant {
    // Retrieve the user's stake details from storage
    UserStake storage userStake = _userStakes[msg.sender][plan];

    // Calculate the duration condition for reward claiming
    bool isAfterPlanDuration = block.timestamp >=
        userStake.startTime + _stakingPlanDurations[plan] * 1 days;

    // Ensure the user is allowed to claim the reward
    require(
        isAfterPlanDuration,
        "Cannot claim rewards before the staking duration expires"
    );

    // Retrieve the total reward for the user
    uint256 reward = claimReward(plan);

    // Transfer the reward to the user
    require(
        IERC20(spunkyTokenAddress).transfer(msg.sender, reward),
        "Transfer failed"
    );

    // Reset the accrued reward and startTime for the user
    userStake.accruedReward = 0;
    userStake.startTime = block.timestamp;

    // Update the stakingDetails array to reflect the new accruedReward and startTime
    _stakingDetails[userStake.index].accruedReward = 0;
    _stakingDetails[userStake.index].startTime = block.timestamp;

    // Emit a ClaimRewards event
    emit ClaimRewards(msg.sender, reward);
}


    function removeStakeFromArray(StakingPlan plan) internal {
        // Retrieve the stake details for the user
        UserStake storage userStake = _userStakes[msg.sender][plan];

        // Ensure the user has an active stake for this plan
        require(userStake.isActive, "You don't have a stake for this plan");

        // Get the last index in the staking details array
        uint256 lastIndex = _stakingDetails.length - 1;

        // If the stake to be removed is not the last one, swap it with the last one
        if (userStake.index != lastIndex) {
            UserStake memory swappedStake = _stakingDetails[lastIndex];

            // Perform the swap
            _stakingDetails[userStake.index] = swappedStake;

            // Update the index for the stake that was moved
            _userStakes[swappedStake.owner][swappedStake.plan].index = userStake
                .index;
        }

        // Remove the last element (which is now the element to be removed)
        _stakingDetails.pop();

        // Delete the user's stake information
        delete _userStakes[msg.sender][plan];
    }

   function unstake(StakingPlan plan) external nonReentrant {
    require(msg.sender != owner(), "Owner cannot stake");
    UserStake storage userStake = _userStakes[msg.sender][plan];
    require(userStake.amount > 0, "No staking balance available");

    bool isAfterPlanDuration = block.timestamp >=
        userStake.startTime + _stakingPlanDurations[plan] * 1 days;

    uint256 reward = claimReward(plan);

    if (!isAfterPlanDuration) {
        // If the unstaking is done before the plan duration, the reward is forfeited
        reward = 0;
    }

    uint256 totalAmount = userStake.amount + reward;

    // Transfer the unstaked amount and reward back to the user
    require(
        IERC20(spunkyTokenAddress).transfer(msg.sender, totalAmount),
        "Transfer failed"
    );

    // Update the total staked amount
    _totalStakedAmount -= userStake.amount;

    // Emit an Unstake event
    emit Unstake(msg.sender, userStake.amount, plan);

    // Remove the user's stake details
    removeStakeFromArray(plan);
}
    function getCanClaimStakingReward(
        StakingPlan plan
    ) external view returns (bool) {
        uint256 stakingStartTime = _userStakes[msg.sender][plan].startTime;
        bool isAfterPlanDuration = block.timestamp >=
            stakingStartTime + _stakingPlanDurations[plan] * 1 days;
        return isAfterPlanDuration;
    }

    function getIsStakingActive(StakingPlan plan) external view returns (bool) {
        return _userStakes[msg.sender][plan].isActive;
    }

    function getStakingDetailsCount() external view returns (uint256) {
        return _stakingDetails.length;
    }

    function getTotalStakedAmount() external view returns (uint256) {
        return _totalStakedAmount;
    }

    function getStakingBalance(
        StakingPlan plan
    ) external view returns (uint256) {
        return _userStakes[msg.sender][plan].amount;
    }

    function getStakingReward(
        StakingPlan plan
    ) external view returns (uint256) {
        // Fetch the user's stake details
        UserStake memory userStake = _userStakes[msg.sender][plan];

        // If the plan is not active for the user, return zero
        if (!userStake.isActive) {
            return 0;
        }

        // If the allocation balance is zero, return the accrued reward
        if (IERC20(spunkyTokenAddress).balanceOf(address(this))  == 0) {
            return userStake.accruedReward;
        }

        // Otherwise, calculate the total reward
        uint256 additional = calculateAccruedReward(userStake.amount, plan);
        return userStake.accruedReward + additional;
    }

    function getAllStakingBalances(
        address user
    ) public view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](5); // Assuming 5 plans
        balances[0] = _userStakes[user][StakingPlan.ThirtyDays].amount;
        balances[1] = _userStakes[user][StakingPlan.NinetyDays].amount;
        balances[2] = _userStakes[user][StakingPlan.OneEightyDays].amount;
        balances[3] = _userStakes[user][StakingPlan.ThreeSixtyDays].amount;
        balances[4] = _userStakes[user][StakingPlan.Flexible].amount;
        return balances;
    }

    function getStakingDetailsPage(
        uint256 start,
        uint256 end
    ) public view returns (UserStake[] memory) {
        // Validate the indices
        require(
            start <= end && end < _stakingDetails.length,
            "Invalid indices"
        );

        // Create a new array to hold the range of UserStakes
        UserStake[] memory page = new UserStake[](end - start + 1);

        // Loop through the _stakingDetails array and populate the 'page' array
        for (uint256 i = start; i <= end; i++) {
            page[i - start] = _stakingDetails[i];
        }

        // Return the 'page' array
        return page;
    }

        function calculateStakingReward(
        uint256 amount,
        StakingPlan plan
    ) internal view returns (uint256) {
        require(amount > 0, "Invalid staking amount");
        uint256 rewardPercentage = _stakingPlanReturns[plan];
        uint256 daysRequired = _stakingPlanDurations[plan];

        if (plan == StakingPlan.Flexible) {
            return 0;
        } else {
            return (amount * rewardPercentage * daysRequired) / (1000 * 365);
        }
    }


    function calculateAccruedReward(
        uint256 amount,
        StakingPlan plan
    ) internal view returns (uint256) {
        require(amount > 0, "Invalid staking amount");
        uint256 startTime = _userStakes[msg.sender][plan].startTime;
        uint256 rewardPercentage = _stakingPlanReturns[plan];
        uint256 elapseTime = block.timestamp - startTime;
        uint256 durationInSeconds = _stakingPlanDurations[plan] * 1 days;
        uint256 secondsInAYear = 365 * 1 days;

        if (elapseTime > durationInSeconds && plan != StakingPlan.Flexible) {
            elapseTime = durationInSeconds;
        }

        // Total days accrued in relation to 365 days (1 year);
        return
            (amount * rewardPercentage * elapseTime) / (1000 * secondsInAYear);
    }
}
