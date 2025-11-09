import { Component, OnInit, ChangeDetectorRef  } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Vote, VoteService } from '../services/vote.service';

@Component({
  selector: 'app-vote',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './vote.component.html',
  styleUrls: ['./vote.component.css']
})
export class VoteComponent implements OnInit {
  votes: Vote[] = [];
  candidateName: string = '';

  constructor(private voteService: VoteService, private cdr: ChangeDetectorRef) {}

  ngOnInit(): void {
    console.log('✅ ngOnInit exécuté');
    this.loadVotes();
  }

  loadVotes() {
  this.voteService.getVotes().subscribe({
    next: data => {
      this.votes = data;
      this.cdr.markForCheck();  // force Angular à mettre à jour la vue
    },
    error: err => console.error(err)
  });
}

  addVote() {
  if (!this.candidateName) return;

  this.voteService.addVote({ candidate: this.candidateName }).subscribe({
    next: vote => {
      this.candidateName = '';       // vide le champ
      this.loadVotes();              // recharge la liste
    },
    error: err => console.error(err)
  });
}
}
