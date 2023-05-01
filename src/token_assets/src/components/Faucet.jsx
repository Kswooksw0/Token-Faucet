import React from "react";
import { useState } from "react";
import { canisterId, createActor } from "../../../declarations/token";
import { AuthClient } from "@dfinity/auth-client";

function Faucet() {
	const [isDisabled, setDisabled] = useState(false);
	const [buttonText, setButtonText] = useState("Gimme some");

	async function handleClick(event) {
		setDisabled(true);
		const authClient = await AuthClient.create();
		const identity = await authClient.getIdentity();
		const authenticatedCanister = createActor(canisterId, {
			agentOptions: identity,
		});

		const claimText = await authenticatedCanister.payOut();
		setButtonText(claimText);
	}

	return (
		<div className="blue window">
			<h2>
				<span role="img" aria-label="tap emoji">
					🚰
				</span>
				Faucet
			</h2>
			<label>
				Get your free Gaxspeed tokens here! Claim 10,000 GAX to your
				account.
			</label>
			<p className="trade-buttons">
				<button id="btn-payout" onClick={handleClick} disabled={isDisabled}>
					{buttonText}
				</button>
			</p>
		</div>
	);
}

export default Faucet;
